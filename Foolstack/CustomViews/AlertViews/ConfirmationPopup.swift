//
//  ConfirmationPopup.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

class ConfirmationPopupConfig: PopupConfiguration, PopupButtonsConfiguration, PopupTextConfiguration {
    enum PopupTypes {
        case simple
        case danger
    }

    var title: String
    var text: String
    
    var confirmButtonText = String(localized: "YES")
    var cancelButtonText = String(localized: "NO")
    var confirmButtonStyle: PopupButtonStyle?
    var cancelButtonStyle: PopupButtonStyle?
    var textAlignment: NSTextAlignment = .center
    var textFontSize: CGFloat = .fontMainSize
    var textColor: UIColor = .themeTextMain
    var popupType: PopupTypes = .simple
    
    var confirmAction: PopupButtonAction?
    var cancelAction: PopupButtonAction?

    init(title: String, text: String, type: PopupTypes = .simple, onConfirm: PopupButtonAction?, onCancel: PopupButtonAction? = nil) {
        self.title = title
        self.text = text
        self.confirmAction = onConfirm
        self.cancelAction = onCancel
        self.popupType = type
        self.textColor = type == .danger ? .themeTextSecondary : .themeTextMain
    }
    
    var buttons: [PopupButtonConfig] {
        var buttons = [PopupButtonConfig]()
        if let action = confirmAction {
            buttons.append(PopupButtonConfig(
                title: confirmButtonText,
                style: confirmButtonStyle ?? PopupButtonStyle.common,
                action: action)
            )
        }
        if let action = cancelAction {
            buttons.append(PopupButtonConfig(
                title: cancelButtonText,
                style: cancelButtonStyle ?? PopupButtonStyle.common,
                action: action)
            )
        }

        return buttons
    }
    
}

class CustomPopupView: PopupViewBase {
    
    private var contentView: UIView!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: PopupConfiguration) {
        super.init(frame:.zero)
        self.config = config
        
        createContent()
    }
    
    deinit {
        //print("DEINIT. ConfirmationPopup")
    }
    
    func createContent() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let mainView = UIView()
        self.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .themeBackgroundMain
        mainView.layer.cornerRadius = 12
        mainView.layer.shadowColor = UIColor.themeShadow1.cgColor
        mainView.layer.shadowOpacity = .shadowOpacity
        mainView.layer.shadowRadius = 16

        let headerBar = HeaderBar(withSlider: true)
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(headerBar)
        headerBar.color = .themeHeader
        headerBar.heightConstraint.constant = 44
        headerBar.pinEdges(to: self, leading: 4, trailing: -4, top: 4)
        headerBar.titleLabel.text = config.title
        
        contentView = UIView()
        mainView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: headerBar.bottomAnchor)
        ])
        
        var yAnchor: NSLayoutYAxisAnchor = contentView.bottomAnchor

        if let popupTextConfig = config as? PopupTextConfiguration {
            fillContentView(config: popupTextConfig)
        }
        
        if let buttonConfig = config as? PopupButtonsConfiguration {
            let buttonsView = PopupButtonsView(configs: buttonConfig.buttons)
            buttonsView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(buttonsView)
            NSLayoutConstraint.activate([
                buttonsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                buttonsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
                buttonsView.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 8)
            ])
            yAnchor = buttonsView.bottomAnchor
        }
        
        self.bottomAnchor.constraint(equalTo: yAnchor).isActive = true
    }
    
    private func fillContentView(config: PopupTextConfiguration) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = CustomFonts.defaultMedium(size: config.textFontSize)
        label.textAlignment = config.textAlignment
        label.textColor = config.textColor
        label.text = config.text
    }
    
    private func createButtonsView() {
        
    }
    
    private func onConfirm() {
//        confirmAction?()
//        confirmAction = nil
        closeView()
    }
    
    private func onCancel() {
//        cancelAction?()
//        cancelAction = nil
        closeView()
    }
    
    override func show(safeInsets: UIEdgeInsets = .zero, animated: Bool = true) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: { [weak self] in
            guard let self = self, let parent = self.superview else {
                return
            }
            let parentSafeInsets = parent.safeAreaInsets
            let parentFrame = parent.frame.inset(by: parentSafeInsets)
            let isRegular = self.isRegular
            var bottomOffsetY = max(parentSafeInsets.bottom, .viewPadding)
            if isRegular {
                bottomOffsetY = (parentFrame.height - self.frame.height) * 0.5
            }
            
            //print("Show ConfirmationPopup. Offset \(bottomOffsetY), parent safeInsets \(parent.safeAreaInsets.bottom)")
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                if let self = self, let constr = self.topConstr {
                    if isRegular {
                        //constr.constant =
                    }
                    //          print("Show OneTextFieldView 2. offset \(-self.frame.height - bottomOffsetY)")
                    constr.constant = -self.frame.height - bottomOffsetY
                    self.superview?.layoutIfNeeded()
                }
            }, completion: nil)
        })
    }
    
}
