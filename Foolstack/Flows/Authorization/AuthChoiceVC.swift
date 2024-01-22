//
//  AuthChoiceVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 16.01.2024.
//

import UIKit
import AuthenticationServices

@MainActor
final class AuthChoiceVC: UIViewController {
    var viewModel: AuthChoiceVM!
    
    init(viewModel: AuthChoiceVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //print("DEINIT. LauncherStartVC")
    }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //subscribeToKeyboardNotifications()
        //        firstField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .themeBackgroundTop
        
        let bv = UIView()
        self.view.addSubview(bv)
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.backgroundColor = .themeBackgroundMain
        bv.layer.cornerRadius = 32
        NSLayoutConstraint.activate([
            bv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            bv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            bv.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            bv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let padding: CGFloat = 24
        
        let logoLabel = UILabel()
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoLabel)
        logoLabel.font = CustomFonts.defaultHeavy(size: 32)
        logoLabel.textColor = .white
        logoLabel.text = "FoolStack"
        logoLabel.pinEdges(to: view.safeAreaLayoutGuide, top: 25, centerX: 0)
        
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        bv.addSubview(sv)
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        NSLayoutConstraint.activate([
            sv.leftAnchor.constraint(equalTo: bv.leftAnchor, constant: padding),
            sv.rightAnchor.constraint(equalTo: bv.rightAnchor, constant: -padding),
            sv.topAnchor.constraint(equalTo: bv.topAnchor, constant: 16),
            sv.bottomAnchor.constraint(equalTo: bv.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        let titleLabel = UILabel()
        sv.addArrangedSubview(titleLabel)
        titleLabel.font = CustomFonts.defaultHeavy(size: 24)
        titleLabel.textColor = .themeTextViewTitle
        titleLabel.text = String(localized: "Login or Registration")
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        
        let contentLabel = UILabel()
        sv.addArrangedSubview(contentLabel)
        contentLabel.font = CustomFonts.defaultRegular(size: 17)
        contentLabel.textColor = .themeTextMain
        contentLabel.text = String(localized: "AUTH_CHOICE_DESCRIPTION")
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        
        let buttonsStack = createButtonsStack()
        sv.addArrangedSubview(buttonsStack)
        
        let termsStack = createTermsStack()
        sv.addArrangedSubview(termsStack)
    }
    
    private func createButtonsStack() -> UIView {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        
        sv.addArrangedSubview(createButton(color: UIColor(named: "MailButton")!, icon: .email, title: "Email", action: #selector(emailPressed)))
        sv.addArrangedSubview(createButton(color: UIColor(named: "GoogleButton")!, icon: .google, title: "Google", action: #selector(googlePressed)))
        sv.addArrangedSubview(createButton(color: UIColor(named: "AppleButton")!, icon: .apple, title: "Apple", action: #selector(applePressed)))
        
        let guestButton = UIButton()
        sv.addArrangedSubview(guestButton)
        guestButton.setTitle(String(localized: "ENTER AS A GUEST", comment: ""), for: .normal)
        guestButton.heightAnchor.constraint(equalToConstant: .buttonSize).isActive = true
        guestButton.addTarget(self, action: #selector(guestPressed), for: .touchUpInside)
        
        sv.addArrangedSubview(guestButton)

        return sv
    }
    
    private func createButton(color: UIColor, icon: IconNames, title: String, action: Selector) -> UIView {
        let v = UIView()
        v.backgroundColor = color
        v.layer.cornerRadius = 12
        v.pinSize(height: .buttonSize)
        
        let gesture = UITapGestureRecognizer(target: self, action: action)
        v.addGestureRecognizer(gesture)
        
        let img = UIImageView(image: UIImage.systemImage(iconName: icon))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .center
        img.tintColor = .themeTextLight
        v.addSubview(img)
        img.pinEdges(to: v, leading: 0, centerY: 0)
        img.pinSize(width: .buttonSize, height: .buttonSize)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(titleLabel)
        titleLabel.font = CustomFonts.defaultHeavy(size: .fontMainSize)
        titleLabel.textColor = .themeTextLight
        titleLabel.text = title
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: v.centerXAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        
        return v
    }
    
    private func createTermsStack() -> UIView {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        
        let titleLabel = UILabel()
        sv.addArrangedSubview(titleLabel)
        titleLabel.font = CustomFonts.defaultHeavy(size: 14)
        titleLabel.textColor = .themeTextSecondary
        titleLabel.text = String(localized: "By creating an account, you agree to")
        titleLabel.numberOfLines = 0

        //let label1 = createLinkLabel(prefix: " • ", linkText: NSLocalizedString("Link_StoreTermsOfUse", comment: "link"), callback: #selector(tapOnStoreTerms))
        
        let label2 = createLinkLabel(prefix: " • ", linkText: String(localized:"Link_TermsOfUse", comment: "link"), callback: #selector(tapOnTerms))
        
        let label3 = createLinkLabel(prefix: " • ", linkText: String(localized:"Link_PrivacyPolicy", comment: "link"), callback: #selector(tapOnPrivacy))
        
        sv.addArrangedSubview(label2)
        sv.addArrangedSubview(label3)
        //termsStack.addArrangedSubview(label1)
        
        return sv
    }
    
    private func createLinkLabel(prefix: String, linkText: String, callback: Selector) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        let textColor = UIColor.themeTextSecondary
        
        let styleBase = Style({
            $0.color = textColor
            $0.font = CustomFonts.defaultSemiBold(size: 14)
        })
        let styleLink = Style({
            $0.color = UIColor.themeTextLink
            $0.underline = (NSUnderlineStyle.thick, nil)
        })
        let st = StyleXML.init(base: styleBase, ["lnk" : styleLink])
        
        label.attributedText = (prefix + linkText).set(style: st)
        
        let gesture = UITapGestureRecognizer(target: self, action: callback)
        label.addGestureRecognizer(gesture)
        return label
    }
    
    //MARK: Actions
    
    @objc func guestPressed() {
        
    }
    
    @objc func emailPressed() {
        let vm = viewModel.createEmailViewModel()
        let vc = AuthVC(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func googlePressed() {
        viewModel.googleSignIn(viewController: self)
    }
    
    @objc func applePressed() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        
        request.nonce = viewModel.generateNonceFoApple()
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.presentationContextProvider = self
        authController.delegate = self
        
        authController.performRequests()
    }
    
    @objc func tapOnStoreTerms() {
        print("Tap on Store terms")
    }
    @objc func tapOnTerms() {
        print("Tap on Terms")
        let url = URL(string: kLink_Terms)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @objc func tapOnPrivacy() {
        print("Tap on Privacy")
        let url = URL(string: kLink_Policy)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private(set) var downloadIndicator: SpinnerProgressVC?
    
    private func showIndicator(_ show: Bool) {
        if show {
            if self.downloadIndicator == nil {
                self.downloadIndicator = SpinnerProgressVC(type: .simple, parent: self, autolayoutView: self.view.superview!, size: 100, color: nil)
            }
        } else {
            self.downloadIndicator?.close()
            self.downloadIndicator = nil
        }
    }

}


//MARK: APPLE AUTH

extension AuthChoiceVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension AuthChoiceVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            print("Canceled")
        case .unknown:
            print("Unknown")
        case .invalidResponse:
            print("invalidResponse")
        case .notHandled:
            print("notHandled")
        case .failed:
            print("failed")
        case .notInteractive:
            print("notInteractive")
        @unknown default:
            print("default")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = credential.user
            let email = credential.email
            let fullName = credential.fullName?.givenName
            
            var tokenString: String?
            if let token = credential.identityToken {
                tokenString = String(data: token, encoding: .utf8)
            }
            
            viewModel.signedInByApple(userId: userId, email: email, name: fullName, token: tokenString)
        }
    }
}
