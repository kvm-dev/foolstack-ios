//
//  ConfirmPopupConfiguration.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 13.01.2024.
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
    
//    deinit {
//        print("DEINIT. ConfirmationPopupConfig")
//    }

    var buttons: [PopupButtonConfig] {
        var buttons = [PopupButtonConfig]()
        if let action = cancelAction {
            buttons.append(PopupButtonConfig(
                title: cancelButtonText,
                style: cancelButtonStyle ?? PopupButtonStyle.common,
                action: action)
            )
        }
        if let action = confirmAction {
            buttons.append(PopupButtonConfig(
                title: confirmButtonText,
                style: confirmButtonStyle ?? PopupButtonStyle.common,
                action: action)
            )
        }

        return buttons
    }
    
}

