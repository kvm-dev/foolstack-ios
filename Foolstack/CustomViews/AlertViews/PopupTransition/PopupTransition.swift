//
//  PopupTransition.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 13.01.2024.
//

import UIKit

@MainActor
class PopupTransition {
    weak var popupView: CustomPopupView?
    let position: PopupPosition
    let appearDirection: PopupAppearDirection
    
    var centerConstraint: NSLayoutConstraint!
    
    init(popupView: CustomPopupView, position: PopupPosition, appearDirection: PopupAppearDirection) {
        self.popupView = popupView
        self.position = position
        self.appearDirection = appearDirection
        
        setupConstrains()
        
        popupView.isHidden = true
    }
    
    private func setupConstrains() {
        guard let popupView = self.popupView, let parentView = popupView.superview else {
            return
        }
        
        popupView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 12).isActive = true
        popupView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -12).isActive = true
        
        let centerConstr = popupView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        centerConstr.priority = .defaultLow
        centerConstr.isActive = true
        self.centerConstraint = centerConstr
    }
    
    func show() {
        guard let popupView = self.popupView, let parentView = popupView.superview else {
            return
        }

        popupView.isHidden = false
//        let constr = popupView.topAnchor.constraint(equalTo: popupView.superview!.bottomAnchor)
//        constr.isActive = true
        let h = popupView.bounds.height
        centerConstraint.constant = parentView.bounds.height * 0.5 + h * 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [weak self] in
            guard let self = self else { return }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
                if let self = self, let constr = self.centerConstraint {
                    constr.constant = 0
                    self.popupView?.superview?.layoutIfNeeded()
                }
            }
        }
    }
    
    func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let popupView = self.popupView, let parentView = popupView.superview else {
            return
        }

        let h = popupView.bounds.height
        let d = parentView.bounds.height * 0.5 + h * 0.5
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            if let self = self, let constr = self.centerConstraint {
                constr.constant = d
                self.popupView?.superview?.layoutIfNeeded()
            }
        } completion: { fin in
            popupView.isHidden = true
            completion?()
        }
    }
}

enum PopupPosition {
    case center
    case top
    case bottom
}

enum PopupAppearDirection {
    case top
    case bottom
    case left
    case right
}
