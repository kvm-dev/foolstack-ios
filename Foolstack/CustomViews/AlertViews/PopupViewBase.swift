//
//  PopupViewBase.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

class PopupViewBase: UIView {
    var config: PopupConfiguration!
    var popupTransformer: PopupTransformer?
    var closeAction: ((PopupViewBase) -> Void)?
    var topConstr: NSLayoutConstraint?
    
    override init(frame: CGRect) {//}, onCancel: @escaping () -> Void  ) {
        super.init(frame: frame)
        //self.cancelAction = onCancel
        
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //print("Deinit PopupViewBase")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        //print("Popup will move")
        if newSuperview == nil {
            //print("Popup will removed")
        }
    }
    
    func closeView() {
        //print("PopupViewBase closeView")
        closeAction?(self)
        closeAction = nil
    }
    
    func show(safeInsets: UIEdgeInsets = .zero, animated: Bool = true) {
        if let transformer = popupTransformer {
            transformer.show()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: { [weak self] in
                guard let self = self else { return }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                    if let self = self, let constr = self.topConstr {
                        constr.constant = -self.frame.height - self.superview!.safeAreaInsets.bottom
                        self.superview?.layoutIfNeeded()
                    }
                }, completion: nil)
            })
        }
    }
    
    open func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            if let self = self, let constr = self.topConstr {
                constr.constant = 0
                self.superview?.layoutIfNeeded()
            }
        }) { _ in
            completion?()
        }
    }
}



extension UIView {
    func setFrameStyle() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .themeBackgroundPopup
        self.layer.shadowColor = UIColor.themeShadow1.cgColor
        //layer.shadowOffset = .init(width: 2, height: 2)
        layer.shadowOpacity = .shadowOpacity
        layer.shadowRadius = 6
    }
}
