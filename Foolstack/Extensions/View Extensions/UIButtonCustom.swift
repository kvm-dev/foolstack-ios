//
//  UIButtonCustom.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import UIKit

extension UIButton {
    static func custom(iconName: IconNames,
                       color: UIColor = .themeColor3,
                       size: CGFloat = .buttonSize,
                       imagePoints: CGFloat = 20) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        ///button.frame = .init(0, 0, .buttonSize, .buttonSize)
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.setImage(.symbolImage(iconName: iconName, pointSize: imagePoints), for: .normal)
        button.tintColor = color
        
        return button
    }
    
    static func custom(systemName: IconNames,
                       color: UIColor = .themeColor3,
                       size: CGFloat = .buttonSize,
                       imagePoints: CGFloat = 20) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        ///button.frame = .init(0, 0, .buttonSize, .buttonSize)
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.setImage(.systemImage(iconName: systemName, pointSize: imagePoints), for: .normal)
        button.tintColor = color
        
        return button
    }
    
    static func customClose() -> UIButton {
        custom(systemName: IconNames.close, imagePoints: 24)
    }
    static func customBack() -> UIButton {
        custom(iconName: IconNames.back)
    }
    //  static func customDelete() -> UIButton {
    //    custom(iconName: IconNames.delete, color: .themeDeleteIcon)
    //  }
    //  static func customHelp() -> UIButton {
    //    custom(iconName: IconNames.none, color: IconNames.help.color)
    //  }
}

