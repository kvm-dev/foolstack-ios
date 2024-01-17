//
//  AuthVM_Code.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 17.01.2024.
//

import Foundation

final class AuthVM_Code: AuthVMBase {
    private var userAuthData: UserResponseData?
    private var uploadNumber = 0
    //    private(set) var googleConfig: GIDConfiguration?
    private var appleNonce = ""
    
    override init(network: NetworkService) {
        super.init(network: network)
        
        //        if let clientId = FirebaseApp.app()?.options.clientID {
        //            googleConfig = GIDConfiguration.init(clientID: clientId)
        //        }
        
        self.titleText = String(localized: "Login or Registration")
        firstKeyboardType = .emailAddress
        //        updateFirstPlaceholder(isError: false, newPlaceholder: NSLocalizedString("Your email address", comment: ""))
        //        updateSecondPlaceholder(isError: false, newPlaceholder: NSLocalizedString("Enter your password", comment: ""))
        //        //messageText = getAttributedText("Password must be at least 6 characters.")
        
        //firstFieldText = "jackowlson100@gmail.com"
        //secondFieldText = "qqq"
        
        //setMessageText("<err>Error text.</err> This is a <a href=\"https://yandex.ru\">link</a>")
        //setMessageText(NSLocalizedString("Password must be at least 6 characters.", comment: ""))
        
        nextButtonTitle = String(localized: "Next", comment: "")
        
        //    $firstFieldText.sink { str in
        //      print("Received first text '\(str)'")
        //    }.store(in: &subscriptions)
    }
    
    override func doNext() {
        if !isValidEmail(firstFieldText ?? "") {
            firstFieldError = true
            handleError(nil)
            return
        }
        
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
        setMessageText("<err>Invalid email address or password. Please check your email address or password and try again.</err>")
    }
    
    private func loginSucces(result: UserProfile) {
        print("login success: userID \(result.userId)")
        //let vm = AuthVM_Code()
        //onShowSignIn?(vm)
    }
    
}
