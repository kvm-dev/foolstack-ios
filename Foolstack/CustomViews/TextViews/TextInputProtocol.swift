//
//  TextInputProtocol.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 19.01.2024.
//

import Foundation
import UIKit

@MainActor
protocol TextInputField: NSCoding {
    @discardableResult func becomeFirstResponder() -> Bool
    var keyboardType: UIKeyboardType { get set }
    var text: String? { get set }
    var attributedPlaceholder: NSAttributedString? { get set }
    func addAction(_ action: @escaping (String?) -> Void, for controlEvents: UIControl.Event)
}

