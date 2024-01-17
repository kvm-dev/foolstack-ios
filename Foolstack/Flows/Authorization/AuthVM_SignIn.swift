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
        
        firstFieldText = "jackowlson100@gmail.com"
        //secondFieldText = "qqq"
        
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
        let vm = AuthVM_Code(network: network)
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
    
    //MARK: Social
    
/*    private func loginSocial(email: String, name: String) {
        let urlStr = "\(kServerDomainAPI2)/auth.php?action=login_soc&login=\(email)&name=\(name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //print("Login social. url:", urlStr)
        if let task: RequestTask<ServerAuthData, AuthServerError> = NetworkInst.request(urlString: urlStr) {
            self.onShowLoading?(true)
            connectSubscription = task.onComplete
                .sink(receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        print("Login social error: \(err.localizedDescription)")
                        self?.onDebugError?(err.localizedDescription)
                    }
                }, receiveValue: { [weak self] result in
                    //print("Login social success. server id \(result.serverId)")
                    self?.loginSucces(result: result)
                })
        } else {
            self.onDebugError?("SocialLogin task creation error")
        }
    }
    
    func signedInByApple(userId: String, email: String?, name: String?, token: String?) {
        let savedId = UserDefaults.standard.string(forKey: "apple_user_id") ?? ""
        var userEmail = UserDefaults.standard.string(forKey: "apple_user_email")
        var userName = UserDefaults.standard.string(forKey: "apple_user_name")
        print("Saved apple email '\(userEmail ?? "")', name '\(userName ?? "")'")
        
        if savedId != userId {
            userEmail = nil
            userName = nil
        }
        UserDefaults.standard.set(userId, forKey: "apple_user_id")
        
        if let email = email,
           userEmail == nil || userEmail!.contains("@privaterelay.appleid.com") {
            UserDefaults.standard.set(email, forKey: "apple_user_email")
            userEmail = email
            print("New apple email '\(email)'")
        }
        if let name = name {
            UserDefaults.standard.set(name, forKey: "apple_user_name")
            userName = name
            print("New apple name '\(name)'")
        }
        
        var emailArg = ""
        var nameArg = ""
        
        if let userEmail = userEmail {
            emailArg = "&email=\(userEmail)"
        }
        if let userName = userName {
            nameArg = "&name=\(userName)"
        }
        
        let urlStr = "\(kServerDomainAPI2)/auth.php?action=login_a&user_id=\(userId)\(emailArg)\(nameArg)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("Login apple. url:", urlStr)
        if let task: RequestTask<ServerAuthData, AuthServerError> = NetworkInst.request(urlString: urlStr) {
            connectSubscription = task.onComplete
                .sink(receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        print("Login apple error: \(err.localizedDescription)")
                        self?.onDebugError?(err.localizedDescription)
                    }
                }, receiveValue: { [weak self] result in
                    print("Login apple success. server id \(result.serverId)")
                    if result.name == nil {
                        result.name = userName
                    }
                    self?.loginSucces(result: result)
                })
        }
        
    }
    
    func generateNonceFoApple() -> String {
        self.appleNonce = randomNonceString()
        return sha256(appleNonce)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
 */
}

