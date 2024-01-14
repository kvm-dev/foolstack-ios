//
//  PopupProtocols.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

protocol PopupConfiguration {
    var title: String { get }
}

protocol PopupButtonsConfiguration {
    var buttons: [PopupButtonConfig] { get }
}

protocol PopupTextConfiguration {
    var text: String { get }
    var textAlignment: NSTextAlignment { get }
    var textFontSize: CGFloat { get }
    var textColor: UIColor { get }
}
