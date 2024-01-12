//
//  PopupViewContainer.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

class PopupViewContainer: UIView {
    var onDismissFinished: (() -> Void)?
    
    private weak var currentPopup: PopupViewBase!
    private var overlay: UIView!
    
    deinit {
        print("~ PopupViewContainer")
    }
    
    init(popupView: PopupViewBase, superview: UIView) {
        super.init(frame: .zero)
        
        superview.addSubview(self)
        self.currentPopup = popupView
        self.addSubview(popupView)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.pinEdges(to: self.superview!, padding: 0)
        
        overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(overlay, at: 0)
        overlay.backgroundColor = UIColor.themeOverlay
        overlay.pinEdges(to: self, padding: 0)
        
        self.layoutIfNeeded()
        currentPopup.show(safeInsets: self.safeAreaInsets, animated: true)
        
        currentPopup.closeAction = { [weak self] popup in
            self?.close()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        overlay.addGestureRecognizer(tapGesture)
    }
    
    @objc private func close() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.overlay.alpha = 0
        } completion: { fin in
            
        }
        
        currentPopup.hide(animated: true) { [weak self] in
            self?.onDismissFinished?()
            self?.removeFromSuperview()
        }
    }
}
