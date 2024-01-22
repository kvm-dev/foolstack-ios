//
//  AuthVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 17.01.2024.
//

import UIKit
import Combine

class AuthVC: UIViewController {
    
    private var keyboardLayoutGuide: KeyboardLayoutGuide!
    private var bottomConstraint: NSLayoutConstraint!
    private var prevKeyboardFrame: CGRect = .zero
    private var bottomView: UIView!
    private var inputField: TextInputField!
    private var nextButton: UIButton!
    private var additionalButton: UIButton!
    private var fieldLabel: UILabel!
    private var descriptionLabel: UILabel!

    private var viewModel: AuthVMBase!
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: AuthVMBase) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT. AuthVC")
    }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //subscribeToKeyboardNotifications()
        inputField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showIndicator(false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeader()
        setupViews()
        initialize()
    }
    
    private func setupHeader() {
        let logoLabel = UILabel()
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoLabel)
        logoLabel.font = CustomFonts.defaultHeavy(size: 32)
        logoLabel.textColor = .white
        logoLabel.text = "FoolStack"
        logoLabel.pinEdges(to: view.safeAreaLayoutGuide, top: 25, centerX: 0)
        
//        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            let backButton = UIButton.custom(systemName: .back, color: .themeTextLight, size: .buttonSize, imagePoints: 32)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(backButton)
            backButton.pinEdges(to: view.layoutMarginsGuide, leading: 0)
            backButton.pinEdges(to: logoLabel, centerY: 0)
            backButton.addAction(UIAction(handler: { [weak self] _ in
                self?.backPressed()
            }), for: .touchUpInside)
            //backButton.pinSize(width: .buttonSize, height: .buttonSize)
//        }
    }
    
    private func setupViews() {
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
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bv.addSubview(titleLabel)
        titleLabel.font = CustomFonts.defaultHeavy(size: 24)
        titleLabel.textColor = .themeTextViewTitle
        titleLabel.text = viewModel.titleText
        titleLabel.numberOfLines = 1
        titleLabel.pinEdges(to: bv, top: 16, centerX: 0)
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bv.addSubview(descriptionLabel)
//        descriptionLabel.font = CustomFonts.defaultRegular(size: 17)
//        descriptionLabel.textColor = .themeTextMain
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
        ])
        
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
        ])
        keyboardLayoutGuide = KeyboardLayoutGuide(parentView: bottomView)
        let constr = keyboardLayoutGuide.topGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        constr.priority = .defaultHigh
        constr.isActive = true

        nextButton = BorderButton(backgroundColor: .themeAccent)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(nextButton)
        nextButton.setTitle(viewModel.nextButtonTitle, for: .normal)
        nextButton.heightAnchor.constraint(equalToConstant: .buttonSize).isActive = true
        nextButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        
        viewModel.$nextButtonEnabled.assign(to: \.isEnabled, on: nextButton)
            .store(in: &subscriptions)
        
        NSLayoutConstraint.activate([
            nextButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 0),
            nextButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: 0),
            nextButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -12)
        ])
        bottomConstraint = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -11)
        //bottomConstraint.isActive = true
        
        let fieldStack = UIStackView()
        fieldStack.translatesAutoresizingMaskIntoConstraints = false
        fieldStack.axis = .vertical
        fieldStack.alignment = .leading
        bottomView.addSubview(fieldStack)

        fieldLabel = UILabel()
        fieldLabel.font = CustomFonts.defaultRegular(size: 13)
        fieldLabel.numberOfLines = 0

        fieldStack.addArrangedSubview(fieldLabel)

        if viewModel.inputType == .pin {
            fieldStack.spacing = 12
            
            let field = PasscodeView(length: 4)
            fieldStack.addArrangedSubview(field)
            //field.heightAnchor.constraint(equalToConstant: 50).isActive = true
            field.configView(
                labelFont: CustomFonts.defaultBold(size: 30),
                labelColor: .themeTextMain,
                cornerRadius: 8,
                pinColor: .themeBackgroundMain,
                pinBorderColor: .themeHeader,
                pinBorderWidth: 1)
            field.setPinSize(.init(60, 60), spacing: 20)
            field.keyboardType = .decimalPad
            self.inputField = field
            
            NSLayoutConstraint.activate([
                fieldStack.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),
                fieldStack.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -12)
            ])
        } else {
            fieldStack.alignment = .fill

            let textField = CustomTextField(backgroundColor: .themeBackgroundMain)
            textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
            fieldStack.addArrangedSubview(textField)
            //textField.attributedPlaceholder
            self.inputField = textField
            
            let divider = UIView()
            divider.backgroundColor = .themeDivider
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            fieldStack.addArrangedSubview(divider)

            NSLayoutConstraint.activate([
                fieldStack.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 0),
                fieldStack.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0),
                fieldStack.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -22)
            ])
        }
        
        additionalButton = UIButton()
        additionalButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(additionalButton)
        NSLayoutConstraint.activate([
            additionalButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 0),
            additionalButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0),
            additionalButton.bottomAnchor.constraint(equalTo: fieldStack.topAnchor, constant: -10),
            additionalButton.heightAnchor.constraint(greaterThanOrEqualToConstant: .buttonSizeSmall),
        ])

        bottomView.topAnchor.constraint(equalTo: additionalButton.topAnchor).isActive = true
//        fieldStack.backgroundColor = .yellow
//        bottomView.backgroundColor = .orange
//        additionalButton.backgroundColor = .magenta
    }
    
    private func initialize() {
        inputField.keyboardType = viewModel.firstKeyboardType
        viewModel.$firstFieldText.assign(to: \.text, on: inputField).store(in: &subscriptions)
        viewModel.$firstFieldPlaceholder.assign(to: \.attributedPlaceholder, on: inputField).store(in: &subscriptions)
        inputField.addAction({ [unowned self] str in
            self.firstFieldTextChanged(str)
        }, for: .editingChanged)

        viewModel.$descriptionText.assign(to: \.attributedText, on: descriptionLabel).store(in: &subscriptions)
        viewModel.$messageText.assign(to: \.attributedText, on: fieldLabel).store(in: &subscriptions)

        viewModel.$firstFieldError.sink { [unowned self] isErr in
          //print("Recieved firstFieldError: \(isErr)")
          //self.inputField.borderColor = isErr ? UIColor.themeDeleteIcon : .themeColor23
          //self.inputField.textColor = isErr ? .themeDeleteIcon : .themeTextMain
        }.store(in: &subscriptions)

        viewModel.$nextButtonEnabled.assign(to: \.isEnabled, on: nextButton).store(in: &subscriptions)
        viewModel.$nextButtonTitle.sink { [unowned self] str in
          self.nextButton.setTitle(str, for: .normal)
        }.store(in: &subscriptions)

        viewModel.$additionalButtonEnabled.assign(to: \.isEnabled, on: additionalButton).store(in: &subscriptions)
        viewModel.$additionalButtonTitle.sink { [unowned self] str in
            self.additionalButton.setAttributedTitle(str, for: .normal)
        }.store(in: &subscriptions)

        viewModel.onShowEnterCode = {[unowned self] vm in self.goToEnterCode(viewModel: vm)}
//        viewModel.onShowSignIn = {[unowned self] vm in self.goToSignIn(vm)}
//        viewModel.onBackToRoot = {[unowned self] in self.backToRoot()}
//        viewModel.onBackToPrevious = {[unowned self] in self.backPressed()}
        viewModel.onLaunchCategoriesFlow = {[unowned self] in self.launchCategoriesFlow()}
        viewModel.onLaunchMainFlow = {[unowned self] in self.launchMainFlow()}
//        viewModel.onDownloadProgress = { [unowned self] p in self.downloadIndicator?.setProgress(p) }
//        viewModel.onSyncLoadError = { [weak self] mess, repeatCallback in self?.showSyncErrorPopup(mess, onRepeat: repeatCallback)}

        viewModel.onShowLoading = {[weak self] show in self?.showIndicator(show) }
    }
    
    @objc func signInPressed() {
        viewModel.doNext()
    }
    
    private func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func launchCategoriesFlow() {
        let vc = CatFlowBuilder.build()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    private func launchMainFlow() {
        let vc = MainTabVC()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    private func firstFieldTextChanged(_ text: String?) {
      viewModel.firstFieldText = text
      if viewModel.firstFieldError {
        viewModel.firstFieldError = false
      }
    }

    @objc func passcodeTextChanged(_ sender: PasscodeView) {
      viewModel.firstFieldText = sender.text
      if viewModel.firstFieldError {
        viewModel.firstFieldError = false
      }
    }

    private func goToEnterCode(viewModel: AuthVM_Code) {
        let vc = AuthVC(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private(set) var downloadIndicator: SpinnerProgressVC?
    
    private func showIndicator(_ show: Bool) {
        if show {
            if self.downloadIndicator == nil {
                self.downloadIndicator = SpinnerProgressVC(type: .simple, parent: self, autolayoutView: self.view.superview!, size: 100, color: nil) { [unowned self] in
                    //self.cancelDownloading()
                }
            }
        } else {
            self.downloadIndicator?.close()
            self.downloadIndicator = nil
        }
    }

}

