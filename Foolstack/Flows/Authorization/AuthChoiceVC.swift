//
//  AuthChoiceVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 16.01.2024.
//

import UIKit

class AuthChoiceVC: UIViewController {
    
    //    private var keyboardLayoutGuide: KeyboardLayoutGuide!
    private var bottomConstraint: NSLayoutConstraint!
    private var prevKeyboardFrame: CGRect = .zero
    private var bottomView: UIView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
        subscribeToKeyboardNotifications()
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
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bv.addSubview(titleLabel)
        titleLabel.font = CustomFonts.defaultHeavy(size: 24)
        titleLabel.textColor = .themeTextViewTitle
        titleLabel.text = String(localized: "Login or Registration")
        titleLabel.numberOfLines = 1
        titleLabel.pinEdges(to: bv, top: 16, centerX: 0)
        
        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        bv.addSubview(contentLabel)
        contentLabel.font = CustomFonts.defaultRegular(size: 17)
        contentLabel.textColor = .themeTextMain
        contentLabel.text =
        """
        Введи адрес электронной почты, чтобы мы могли определить есть ли у тебя учетная запись в нашем сервисе.  В случае если учетной записи у тебя нет, мы сможем тебя зарегистрировать.
        """
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            contentLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            contentLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
        ])
        
        
        let sv = UIStackView()
        bottomView = sv
        sv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sv)
        sv.axis = .vertical
        NSLayoutConstraint.activate([
            sv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            sv.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
        ])
        bottomConstraint = sv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -11)
        bottomConstraint.isActive = true
        
        //        keyboardLayoutGuide = KeyboardLayoutGuide(parentView: sv)
        //        let constr = keyboardLayoutGuide.topGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -11)
        //        constr.priority = .defaultHigh
        //        constr.isActive = true
        
        let mailLabel = UILabel()
        sv.addArrangedSubview(mailLabel)
        mailLabel.font = CustomFonts.defaultRegular(size: 13)
        mailLabel.textColor = .themeTextViewTitle
        mailLabel.text = "Email"
        mailLabel.numberOfLines = 1
        
        let textField = CustomTextField(backgroundColor: .themeBackgroundMain)
        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        sv.addArrangedSubview(textField)
        textField.placeholder = "Enter email"
        
        let divider = UIView()
        divider.backgroundColor = .themeBackgroundSecondary
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        sv.addArrangedSubview(divider)
        
        let v1 = UIView()
        v1.heightAnchor.constraint(equalToConstant: 22).isActive = true
        sv.addArrangedSubview(v1)
        
        let loginButton = BorderButton(backgroundColor: .themeAccent)
        sv.addArrangedSubview(loginButton)
        loginButton.setTitle(String(localized: "Next", comment: ""), for: .normal)
        loginButton.heightAnchor.constraint(equalToConstant: .buttonSize).isActive = true
        loginButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        
        let v2 = UIView()
        v2.heightAnchor.constraint(equalToConstant: 16).isActive = true
        sv.addArrangedSubview(v2)
        
        textField.becomeFirstResponder()
        
        //TODO: localize
        
        
        
        
        
    }
    
    @IBAction func signInPressed() {
    }
    
}


//MARK: Keyboard

private extension AuthChoiceVC {
    
    private func subscribeToKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        //notificationCenter.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //    notificationCenter.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
    }
    
    @objc
    func keyboardDidChangeFrame(_ notification: Notification) {
        keyboardFrameChanged(notification)
    }
    
    func keyboardFrameChanged(_ notification: Notification) {
        let owningView: UIView = self.bottomView
        //guard let owningView = self.topGuide.owningView else { return }
        guard let window = owningView.window else { return }
        guard let keyboardInfo = KeyboardInfo(userInfo: notification.userInfo),
              keyboardInfo.endFrame != prevKeyboardFrame
        else { return }
        
        prevKeyboardFrame = keyboardInfo.endFrame
        
        var owningViewFrame = window.convert(owningView.frame, from: owningView.superview)
        owningViewFrame.origin.x = 0
        var coveredFrame = owningViewFrame.intersection(keyboardInfo.endFrame)
        coveredFrame = window.convert(coveredFrame, to: owningView.superview)
        
        let bottomSafeY = view.safeAreaInsets.bottom
        let keybTop = window.frame.height - keyboardInfo.endFrame.minY
        let keybBottom = window.frame.height - keyboardInfo.endFrame.maxY
        let fieldTop = window.frame.height - bottomView.frame.maxY + 44
        let fieldBottom = window.frame.height - bottomView.frame.maxY
        let diff = keybBottom - fieldTop
        print("keyboardFrameChanged. keyboard frame \(keyboardInfo.endFrame)\n\twindow.frame \(window.frame)\n\tUIScreen.bounds \(UIScreen.main.bounds)\n\tMain frame \(bottomView.frame)\n\tMainFram MaxY \(bottomView.frame.maxY)\n\tCoveredFrame \(coveredFrame)\n\tOwningViewFrame \(owningViewFrame)\n\tKeyboard top \(keybTop) - field bottom \(fieldBottom) = \(keybTop - fieldBottom)\n\t Is keyboard attached? \(keyboardInfo.isAttached)")
        
        if keybTop > 0 /*&& diff < 0*/ && keyboardInfo.endFrame.width > 300 {
            keyboardInfo.animateAlongsideKeyboard { [unowned self] in
                if keyboardInfo.isAttached {
                    self.bottomConstraint.constant = -keyboardInfo.endFrame.height + bottomSafeY// -coveredFrame.height + bottomSafeY// -(keybTop - fieldBottom)
                } else {
                    self.bottomConstraint.constant = 0
                }
                //owningView.layoutIfNeeded()
            }
        } else {
            keyboardInfo.animateAlongsideKeyboard { [unowned self] in
                self.bottomConstraint.constant = 0
                //owningView.layoutIfNeeded()
            }
            
        }
        //    keyboardInfo.animateAlongsideKeyboard {
        //self.bottomConstraint.constant = -coveredFrame.height
        //owningView.layoutIfNeeded()
        //    }
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardInfo = KeyboardInfo(userInfo: notification.userInfo) else { return }
        //print("keyboardWillShow. keyboard frame \(keyboardInfo.endFrame)")
        keyboardFrameChanged(notification)
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        guard let keyboardInfo = KeyboardInfo(userInfo: notification.userInfo) else { return }
        //print("keyboardWillHide. keyboard frame \(keyboardInfo.endFrame)")
        keyboardInfo.animateAlongsideKeyboard { [weak self] in
            self?.bottomConstraint.constant = 0
        }
        //self.bottomConstraint.constant = 0.0
        //self.topGuide.owningView?.layoutIfNeeded()
        //self.parentView.layoutIfNeeded()
    }
}
