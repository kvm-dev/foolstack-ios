//
//  StartVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 16.01.2024.
//

import UIKit

class StartVC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .themeBackgroundTop
        
        let bv = UIView()
        self.view.addSubview(bv)
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.backgroundColor = .themeBackgroundMain
        bv.layer.cornerRadius = 32
        NSLayoutConstraint.activate([
            bv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 125),
            bv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            bv.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            bv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let padding: CGFloat = 40
        
        let logoLabel = UILabel()
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoLabel)
        logoLabel.font = CustomFonts.defaultHeavy(size: 32)
        logoLabel.textColor = .white
        logoLabel.text = "FoolStack"
        logoLabel.pinEdges(to: view.safeAreaLayoutGuide, top: 40, centerX: 0)
        
        let imageView = UIImageView(image: UIImage(named: "foolstack.start"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        bv.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.pinEdges(to: bv, leading: padding, top: 0)
        imageView.pinSize(height: 256)
        
        let guestButton = UIButton()
        guestButton.translatesAutoresizingMaskIntoConstraints = false
        bv.addSubview(guestButton)
        guestButton.titleLabel?.font = CustomFonts.defaultMedium(size: 17)
        guestButton.setTitleColor(.themeAccent, for: .normal)
        guestButton.setTitle(String(localized: "ENTER AS A GUEST"), for: .normal)
        NSLayoutConstraint.activate([
            guestButton.centerXAnchor.constraint(equalTo: bv.centerXAnchor),
            guestButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            guestButton.heightAnchor.constraint(equalToConstant: .buttonSize)
        ])
        guestButton.addTarget(self, action: #selector(guestPressed), for: .touchUpInside)

        let loginButton = BorderButton(backgroundColor: .themeAccent)
        bv.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle(String(localized: "Sign in or Register", comment: ""), for: .normal)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: bv.leadingAnchor, constant: padding),
            loginButton.trailingAnchor.constraint(equalTo: bv.trailingAnchor, constant: -padding),
            loginButton.bottomAnchor.constraint(equalTo: guestButton.topAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: .buttonSizeBig)
        ])
        loginButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)

        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        bv.addSubview(cv)
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            cv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            cv.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            cv.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -16)
        ])

        let style1 = NSMutableParagraphStyle()
        style1.alignment = .center
        style1.lineBreakMode = .byWordWrapping
        let attr1: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.themeTextViewTitle,
            .font: CustomFonts.defaultMedium(size: 22),
            .paragraphStyle: style1
        ]
        let style2 = NSMutableParagraphStyle()
        style2.alignment = .left
        style2.lineBreakMode = .byWordWrapping
        let attr2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.themeTextMain,
            .font: CustomFonts.defaultMedium(size: .fontMainSize),
            .paragraphStyle: style2
        ]

        //TODO: localize
        let str = NSMutableAttributedString(string: "Поможем найти работу", attributes: attr1)
        str.append(NSAttributedString(string: "\n\nТехническое собеседование или скрининг с HR? Поможем подготовиться\n\nНе хватает практики? Проверь себя в наших тестовых заданиях и получи обратную связь", attributes: attr2))
        
        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        bv.addSubview(contentLabel)
        contentLabel.attributedText = str
        contentLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            contentLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            contentLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            contentLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -16)
        ])

    }
    
    @IBAction func signInPressed() {
        let vc = AuthChoiceVC(
            viewModel: AuthChoiceVM(
                network: MockNetworkClient(),
                userStorage: UserStorage(config: LocalUserStarageConfig())
            ))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func guestPressed() {
        showLanguagesPopup()
    }
    
    func showLanguagesPopup() {
    }
}
