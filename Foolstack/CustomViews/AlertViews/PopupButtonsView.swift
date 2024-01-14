//
//  PopupButtonsView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

class PopupButtonsView: UIView {
    /// Parameter 1: Should dismiss
    /// Parameter 2: Action on dismiss finished
    var onPress: ((Bool, CloseAction?) -> Void)?
    weak var buttonsView: UIView!
    var buttonConfigs: [PopupButtonConfig] = []
    
    let path = UIBezierPath()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setFrameStyle()
        buttonsView.layer.borderColor = UIColor.themeBackgroundPopup.cgColor
    }
    
    init(configs: [PopupButtonConfig]) {
        super.init(frame: .zero)
        self.buttonConfigs = configs
        
        self.setFrameStyle()
        
        var buttons = [UIButton]()
        for buttonConfig in buttonConfigs {
            buttons.append(createButton(buttonConfig))
        }
        
        let buttonsView = UIStackView(arrangedSubviews: buttons)
        self.buttonsView = buttonsView
        addSubview(buttonsView)
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.axis = .horizontal
        buttonsView.distribution = .fillEqually
        let constraints = [
            buttonsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            buttonsView.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func createButton(_ buttonConfig: PopupButtonConfig) -> UIButton {
        let button1 = BorderButton(backgroundColor: .themeHeader, borderColor: .themeBackgroundMain, borderWidth: 8, padding: 0)
        button1.titleLabel?.font = CustomFonts.SFSemibold.font(size: .fontMainSize)
        button1.setTitle(buttonConfig.title, for: .normal)
        button1.setTitleColor(buttonConfig.style.normalTextColor, for: .normal)
        button1.setTitleColor(buttonConfig.style.disabledTextColor, for: .disabled)
        button1.addAction(UIAction(handler: { [weak self] action in
            let needHide = buttonConfig.action.onPress()
            self?.onPress?(needHide, buttonConfig.action.onDismissed)
        }), for: .touchUpInside)
        button1.heightAnchor.constraint(equalToConstant: 44).isActive = true

        return button1
    }

}


struct PopupButtonStyle {
    let normalColor: UIColor
    let normalTextColor: UIColor
    let disabledColor: UIColor?
    let disabledTextColor: UIColor?
    
    init(normalColor: UIColor, normalTextColor: UIColor, disabledColor: UIColor? = nil, disabledTextColor: UIColor? = nil) {
        self.normalColor = normalColor
        self.normalTextColor = normalTextColor
        self.disabledColor = disabledColor
        self.disabledTextColor = disabledTextColor
    }
    
    static var common: PopupButtonStyle {
        PopupButtonStyle(normalColor: .themeBackgroundSecondary, normalTextColor: .themeTextMain, disabledColor: nil, disabledTextColor: .themeTextDisabled)
    }
}

struct PopupButtonConfig {
    let title: String
    let style: PopupButtonStyle
    let action: PopupButtonAction
}

struct PopupButtonAction {
    let onPress: () -> Bool
    let onDismissed: (() -> Void)?
    
    init(onPress: (() -> Bool)? = nil, onDismissed: (() -> Void)? = nil) {
        self.onPress = onPress ?? { return true }
        self.onDismissed = onDismissed
    }
}
