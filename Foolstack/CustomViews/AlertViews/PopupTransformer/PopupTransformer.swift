//
//  PopupTransformer.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

@MainActor
class PopupTransformer: NSObject {
    unowned var view: UIView
    
    var alignment: PopupAlignment
    var layoutGuide: UILayoutGuide!
    
    var initialPopupSize = CGSize(375, 312)
    var originalPopupFrame: CGRect = .zero
    var compactPopupFrame: CGRect = .zero
    
    init(view: UIView, alignment: PopupAlignment = .vertical) {
        self.view = view
        self.alignment = alignment
    }
    
    func show() {
    }
    
    func hide(completion: (() -> Void)?) {
    }
    
}



enum PopupAlignment {
    case vertical
    case horizontal
    case both
}
