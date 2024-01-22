//
//  AuthVM_SignIn.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 17.01.2024.
//

let kPasscodeLength = 4

import Combine
//import GoogleSignIn
//import Firebase
import UIKit
//import CryptoKit

@MainActor
final class AuthVM_SignIn: AuthVMBase {
    private var userAuthData: UserResponseData?
    private var uploadNumber = 0
//    private(set) var googleConfig: GIDConfiguration?
    private var appleNonce = ""
    
    override init(network: NetworkService, userStorage: UserStorage) {
        super.init(network: network, userStorage: userStorage)
        
//        if let clientId = FirebaseApp.app()?.options.clientID {
//            googleConfig = GIDConfiguration.init(clientID: clientId)
//        }
        
        firstKeyboardType = .emailAddress
        titleText = String(localized: "Login or Registration")
        //TODO: localize
        descriptionText = getAttributedText("Введи адрес электронной почты, чтобы мы могли определить есть ли у тебя учетная запись в нашем сервисе.\n\nВ случае если учетной записи у тебя нет, мы сможем тебя зарегистрировать.", fontColor: .themeTextMain, font: CustomFonts.defaultRegular(size: 15))
//        updateFirstPlaceholder(isError: false, newPlaceholder: NSLocalizedString("Your email address", comment: ""))
//        updateSecondPlaceholder(isError: false, newPlaceholder: NSLocalizedString("Enter your password", comment: ""))
//        //messageText = getAttributedText("Password must be at least 6 characters.")
        
        //firstFieldText = "jackowlson100@gmail.com"
        
        //setMessageText("<err>Error text.</err> This is a <a href=\"https://yandex.ru\">link</a>")
        //setMessageText(NSLocalizedString("Password must be at least 6 characters.", comment: ""))
        
        nextButtonTitle = String(localized: "Next", comment: "")
        
        $firstFieldText.sink { str in
            print("Received first text '\(str)'")
            self.nextButtonEnabled = self.isValidEmail(str ?? "")
        }.store(in: &subscriptions)
    }
    
    override func doNext() {
//        if !isValidEmail(firstFieldText ?? "") {
//            firstFieldError = true
//            handleError(nil)
//            return
//        }
        
        Task {
            self.onShowLoading?(true)
            do {
                let responseData = try await self.network.signIn(email: firstFieldText!)
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
        setMessageText("<err>Invalid email address or password. Please check your email address or password and try again.</err>")
    }
    
    private func loginSucces(result: LoginResponseData) {
        print("Passcode: \(result.code)")
        let vm = AuthVM_Code(email: firstFieldText!, network: network, userStorage: userStorage)
        onShowEnterCode?(vm)
    }
 

    private func loginComplete() {
        //print("Login complete")
        guard let userAuthData = userAuthData else {
            return
        }
        
        //    super.loginWasComplete(login: userAuthData.login ?? firstFieldText!, authData: userAuthData)
        //super.loginWasComplete(authData: userAuthData)
    }
    

}

