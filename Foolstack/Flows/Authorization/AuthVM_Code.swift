//
//  AuthVM_Code.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 17.01.2024.
//

import Foundation
import UIKit
import Combine

final class AuthVM_Code: AuthVMBase {
    private var userAuthData: UserResponseData?
    private var uploadNumber = 0
    //    private(set) var googleConfig: GIDConfiguration?
    private var appleNonce = ""
    
    private var timerSubscription: AnyCancellable?
    private var secondsLeft = 60
    
    init(email: String, network: NetworkService, userStorage: UserStorage) {
        super.init(network: network, userStorage: userStorage)

        //        if let clientId = FirebaseApp.app()?.options.clientID {
        //            googleConfig = GIDConfiguration.init(clientID: clientId)
        //        }
        
        self.inputType = .pin
        self.titleText = String(localized: "Login or Registration")
        firstKeyboardType = .numberPad
        //        updateFirstPlaceholder(isError: false, newPlaceholder: NSLocalizedString("Your email address", comment: ""))
        //        updateSecondPlaceholder(isError: false, newPlaceholder: NSLocalizedString("Enter your password", comment: ""))
        //        //messageText = getAttributedText("Password must be at least 6 characters.")
        
        //firstFieldText = "jackowlson100@gmail.com"
        //secondFieldText = "qqq"
        
        descriptionText = getAttributedText("Мы отправили тебе письмо на электронную почту <lnk>“\(email)”</lnk> в письме код из 4х цифр, введи код ниже и сможешь подтвердить свою учетную запись.\n\nОбращаем внимание, что код подтверждения действителен в течение суток.", fontColor: .themeTextMain, font: CustomFonts.defaultRegular(size: 15))

        //setMessageText("<err>Error text.</err> This is a <a href=\"https://yandex.ru\">link</a>")
        setMessageText("Код подтверждения")
        
        additionalButtonTitle = getButtonText("RESEND CODE", withUnderline: true)
        nextButtonTitle = String(localized: "Next", comment: "")
        
        $firstFieldText.sink { str in
            print("Received first text '\(str)'")
            self.nextButtonEnabled = str?.count == 4
        }.store(in: &subscriptions)

        $firstFieldError.sink { [unowned self] isErr in
            if !isErr {
                self.setMessageText("Код подтверждения")
            }
        }.store(in: &subscriptions)

        codeWasSend()
    }
    
    override func doNext() {
        Task {
            self.onShowLoading?(true)
            do {
                let responseData = try await self.network.sendLoginCode(code: firstFieldText!)
                self.loginSucces(result: responseData)
            } catch let error as NetworkAPIError {
                self.onShowLoading?(false)
                self.handleError(error)
            } catch {
                self.onShowLoading?(false)
                printToConsole(error)
            }
        }
        
    }
    
    private func handleError(_ error: NetworkAPIError?) {
        if let error = error {
            switch error {
            case .responseFailure(let msg):
                printToConsole("Sign in error: \(msg)")
                //firstFieldText = ""
                firstFieldError = true
            default:
                break
            }
        }
        setMessageText("<err>Неверный код.</err>")
    }
    
    private func loginSucces(result: UserProfile) {
        print("login success: userID \(result.userId)")
        loginWasComplete(authData: result)
    }
    
    //MARK: Resend timer
    
    private func codeWasSend() {
        launchTimer()
    }
    
    private func codeWasResend() {
        launchTimer()
    }
    
    private func launchTimer() {
        secondsLeft = 60
        self.setTimerButtonText(seconds: self.secondsLeft)
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timerSubscription = timer.sink { [weak self] output in
            guard let self = self else {return}
            self.secondsLeft -= 1
            //print("Seconds left \(self.secondsLeft)")
            self.setTimerButtonText(seconds: self.secondsLeft)
            if self.secondsLeft <= 0 {
                self.timerFinished()
            }
        }
    }
    
    private func setTimerButtonText(seconds: Int) {
        let enabled = seconds <= 0
        additionalButtonEnabled = enabled
        let color = enabled ? UIColor.themeAccent : UIColor.themeIndicator
        let styleBase = Style{
            $0.font = CustomFonts.defaultSemiBold(size: .fontMainSize)
            $0.underline = (NSUnderlineStyle.thick, nil)
            $0.color = color
        }
        let styleTimer = Style({
            $0.font = CustomFonts.defaultRegular(size: 12)
            $0.color = color
        })
        let st = StyleXML.init(base: styleBase, ["i" : styleTimer])
        let text = NSLocalizedString("RESEND CODE", comment: "") + (enabled ? "" : "<i> (\(seconds) sec)</i>")
        additionalButtonTitle = text.set(style: st)
    }
    
    private func timerFinished() {
        self.timerSubscription?.cancel()
        self.timerSubscription = nil
    }
    
}
