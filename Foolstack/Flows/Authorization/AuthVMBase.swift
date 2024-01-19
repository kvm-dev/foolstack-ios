//
//  AuthVMBase.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 17.01.2024.
//

import Foundation
import UIKit
import Combine

@MainActor
class AuthVMBase {
    enum TextInputType {
        case text
        case pin
    }

    var titleText = ""
    var firstKeyboardType: UIKeyboardType = .emailAddress
    @Published var firstFieldText: String?
    var firstFieldPlaceholderString: String?
    @Published var firstFieldPlaceholder: NSAttributedString?
    @Published var firstFieldError = false
    @Published var messageText: NSAttributedString?
    @Published var descriptionText: NSAttributedString?
    @Published var nextButtonTitle: String!
    @Published var nextButtonEnabled = false
    @Published var additionalButtonTitle: NSAttributedString?
    @Published var additionalButtonEnabled = false
    var inputType: TextInputType = .text
    
    var onShowEnterCode: ((AuthVM_Code) -> Void)?
    var onShowSignIn: ((AuthVM_SignIn?) -> Void)?
    var onBackToRoot: EmptyCallback?
    var onBackToPrevious: EmptyCallback?
    var onComplete: EmptyCallback?
    var onDebugError: ((String) -> Void)?
    var onSyncLoadError:((String, EmptyCallback?) -> Void)?
    /// Show loading indicator
    var onShowLoading: ((Bool) -> Void)?
    var onDownloadProgress: ((Float) -> Void)?
    
    var connectSubscription: AnyCancellable?
    var subscriptions = Set<AnyCancellable>()
    
    private(set) var network: NetworkService

    init(network: NetworkService) {
        self.network = network
        
        $firstFieldError.sink { [weak self] isError in
            self?.updateFirstPlaceholder(isError: isError)
        }.store(in: &subscriptions)
    }
    
    func setMessageText(_ text: String) {
        let styleBase = Style({
            $0.color = UIColor.themeTextSecondary
            $0.font = CustomFonts.defaultSemiBold(size: 12)
        })
        let styleError = Style({
            $0.color = UIColor.red// UIColor.themeStatPopupBad
        })
        let styleLink = Style({
            $0.color = UIColor.blue// UIColor.themeSpecialIcon
        })
        let st = StyleXML.init(base: styleBase, ["err" : styleError, "lnk" : styleLink])
        messageText = text.set(style: st)
    }
    
    func getAttributedText(_ text: String, fontColor: UIColor, font: UIFont = CustomFonts.defaultRegular(size: 17)) -> NSAttributedString {
        let styleBase = Style({
            $0.color = fontColor
            $0.font = font
        })
        let styleError = Style({
            $0.color = UIColor.themeTextError
        })
        let styleLink = Style({
            $0.color = UIColor.themeTextLink
        })
        let st = StyleXML.init(base: styleBase, ["err" : styleError, "lnk" : styleLink])
        return text.set(style: st)
    }
    
    func getPlaceholderAttribText(_ text: String) -> NSAttributedString {
        getAttributedText(text, fontColor: UIColor.themeTextSecondary)
    }
    
    func updateFirstPlaceholder(isError: Bool, newPlaceholder: String? = nil) {
        if let newPlaceholder = newPlaceholder {
            firstFieldPlaceholderString = newPlaceholder
        }
        guard let placeholder = firstFieldPlaceholderString else {
            firstFieldPlaceholder = nil
            return
        }
        let pref = isError ? "<err>" : ""
        let suf = isError ? "</err>" : ""
        firstFieldPlaceholder = getPlaceholderAttribText(pref + placeholder + suf)
    }
    
    func getButtonText(_ text: String, withUnderline: Bool) -> NSAttributedString {

        let styleBase = Style{
            $0.color = UIColor.themeTextLink
            $0.underline = (NSUnderlineStyle.thick, nil)
            $0.font = CustomFonts.defaultSemiBold(size: .fontMainSize)
        }
        
        return text.set(style: styleBase)
    }
    
    func doNext() { }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func messagePressed() {}
    
    func additionalPressed() {}
    
    func loginWasComplete(authData: UserProfile) {
        onComplete?()
        //NotificationCenter.default.post(name: .notifLoginComplete, object: nil)
    }
    
    func cancelDownloading() {}
    
}
