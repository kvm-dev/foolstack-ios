//
//  PopupManager.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

@MainActor
class PopupManager {
    static let shared = PopupManager()
    private init(){}
    
    public func launch(view: PopupConfiguration) {
        
        guard let rootVC = topMostController() else { return }
        
        if let ref = rootVC as? PopupViewController {
            ref.addView(view)
        }
        else {
            let alertXVC = PopupViewController()
            alertXVC.addView(view)
            alertXVC.modalPresentationStyle = .overFullScreen
            //alertXVC.view.backgroundColor = UIColor.clear
            alertXVC.modalTransitionStyle = .crossDissolve
            
            //AlertX_View.currentAlertXVCReference = alertXVC
            
            rootVC.present(alertXVC, animated: true, completion: nil)
        }
    }
    
    public func launch(view: PopupConfiguration, parent: UIViewController, onClose: (() -> Void)? = nil) {
        
        if let ref = parent.presentedViewController as? PopupViewController {
            ref.addView(view)
            if let onClose = onClose {
                ref.onDismissFinished = onClose
            }
        }
        else {
            let alertXVC = PopupViewController()
            alertXVC.addView(view)
            alertXVC.modalPresentationStyle = .overFullScreen
            //alertXVC.view.backgroundColor = UIColor.clear
            alertXVC.modalTransitionStyle = .crossDissolve
            
            //AlertX_View.currentAlertXVCReference = alertXVC
            
            parent.present(alertXVC, animated: true, completion: nil)
            if let onClose = onClose {
                alertXVC.onDismissFinished = onClose
            }
        }
    }
    
    public func launch(view: CustomPopupView, superview: UIView, onClose: (() -> Void)? = nil) {
        
        let popupContainer = PopupViewContainer(popupView: view, superview: superview)
        if let onClose = onClose {
            popupContainer.onDismissFinished = onClose
        }
    }
    
    func topMostController() -> UIViewController? {
        return UIApplication.shared.topViewController
    }
    
}


extension UIApplication {
    var topViewController: UIViewController? {
        // Get connected scenes
        let window = self.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
        
        var parentController = window?.rootViewController
        while parentController?.presentedViewController != nil
                && parentController != parentController?.presentedViewController {
            parentController = parentController?.presentedViewController
        }
        
        return parentController
    }}
