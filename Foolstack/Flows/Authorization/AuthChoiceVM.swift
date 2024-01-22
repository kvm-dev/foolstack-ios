//
//  AuthChoiceVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 21.01.2024.
//

import Foundation
import UIKit
import CryptoKit

@MainActor
class AuthChoiceVM {
    var onShowLoading: ((Bool) -> Void)?

    private var appleNonce = ""
    private(set) var network: NetworkService
    private(set) var userStorage: UserStorage
    
    init(network: NetworkService, userStorage: UserStorage) {
        self.network = network
        self.userStorage = userStorage
        
    }
    
    func createEmailViewModel() -> AuthVM_SignIn {
        AuthVM_SignIn(network: network, userStorage: userStorage)
    }
    
    //MARK: Social
    
    func googleSignIn(viewController: UIViewController) {
/*        if let googleConfig = googleConfig {
            GIDSignIn.sharedInstance.signIn(with: googleConfig, presenting: viewController) { [weak self] user, error in
                if let error = error {
                    print("Google sign in error:", error)
                    return
                }
                guard let user = user else {
                    print("Google user is nil")
                    return
                }
                guard let idToken = user.authentication.idToken else {
                    print("Google user idToken is nil")
                    return
                }
                guard let userProfile = user.profile else {
                    print("Google user profile is nil")
                    return
                }
                let fullName = userProfile.name
                //        let givenName = userProfile.givenName ?? ""
                //        let familyName = userProfile.familyName ?? ""
                let email = userProfile.email
                //        print("User profile. FullName '\(fullName)', givenName '\(givenName)', familyName '\(familyName)'")
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.authentication.accessToken)
                Auth.auth().signIn(with: credential) { [weak self] authResult, authError in
                    if let authError = authError {
                        print("Firebase signIn error:", authError.localizedDescription)
                        return
                    }
                    print("Firebase signedIn with Google success")
                    self?.firebaseSignedIn(email: email, name: fullName)
                }
                self?.loginSocial(email: email, name: fullName)
            }
        }
 */
    }

    private func signedInViaGooglw(email: String, name: String) {
        Task {
            self.onShowLoading?(true)
            do {
                let responseData = try await self.network.signedInViaGoogle(email: email, name: name)
                //self.loginSucces(result: responseData)
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
                printToConsole("Sign in via google error: \(msg)")
            default:
                break
            }
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
        
        Task {
            self.onShowLoading?(true)
            do {
                let responseData = try await self.network.signedInViaApple(userId: userId, email: emailArg, name: nameArg)
                //self.loginSucces(result: responseData)
            } catch let error as NetworkAPIError {
                self.onShowLoading?(false)
                self.handleError(error)
            } catch {
                self.onShowLoading?(false)
                printToConsole(error)
            }
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
    
}
