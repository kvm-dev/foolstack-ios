//
//  KeyboardLayout.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 16.01.2024.
//

import Foundation
import UIKit

/// Used to create a layout guide that pins to the top of the keyboard
@MainActor
final class KeyboardLayoutGuide {
    
    private let notificationCenter: NotificationCenter
    private let bottomConstraint: NSLayoutConstraint
    private var prevKeyboardFrame: CGRect = .zero
    
    // MARK: - Properties
    let topGuide: UILayoutGuide
    unowned let parentView: UIView
    
    // MARK: - Lifecycle
    init(parentView: UIView, notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        self.parentView = parentView
        self.topGuide = UILayoutGuide()
        self.topGuide.identifier = "Keyboard Layout Guide"
        
        let superview = parentView.superview!
        superview.addLayoutGuide(self.topGuide)
        
        self.bottomConstraint = parentView.bottomAnchor.constraint(equalTo: self.topGuide.bottomAnchor, constant: 0)
        self.bottomConstraint.priority = .required
        NSLayoutConstraint.activate([
            self.topGuide.heightAnchor.constraint(equalToConstant: 1.0),
            self.topGuide.widthAnchor.constraint(equalToConstant: 100),
            //parentView.topAnchor.constraint(equalTo: self.topGuide.topAnchor, constant: 50),
            //parentView.leadingAnchor.constraint(equalTo: self.topGuide.leadingAnchor),
            //parentView.trailingAnchor.constraint(equalTo: self.topGuide.trailingAnchor),
            self.bottomConstraint])
        
        //    notificationCenter.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    deinit {
        self.notificationCenter.removeObserver(self)
    }
}

// MARK: - Private
private extension KeyboardLayoutGuide {
    
    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        keyboardFrameChanged(notification)
    }
    
    func rere(_ notification: Notification) {
        let owningView = self.parentView
        //guard let owningView = self.topGuide.owningView else { return }
        guard let window = owningView.window else { return }
        guard let keyboardInfo = KeyboardInfo(userInfo: notification.userInfo),
              keyboardInfo.endFrame != prevKeyboardFrame
        else { return }
        
        prevKeyboardFrame = keyboardInfo.endFrame
        
        var owningViewFrame = window.convert(owningView.frame, from: owningView.superview)
        owningViewFrame.origin.x = 0
        var coveredFrame = owningViewFrame.intersection(keyboardInfo.endFrame)
        coveredFrame = window.convert(coveredFrame, to: owningView.superview)
        
        let bottomSafeY = owningView.superview!.safeAreaInsets.bottom
        let keybTop = window.frame.height - keyboardInfo.endFrame.minY
        let keybBottom = window.frame.height - keyboardInfo.endFrame.maxY
        //    let fieldTop = window.frame.height - mainView.frame.maxY + 44
        //    let fieldBottom = window.frame.height - mainView.frame.maxY
        //    //    let diff = keybBottom - fieldTop
        //    print("keyboardFrameChanged. keyboard frame \(keyboardInfo.endFrame)\n\twindow.frame \(window.frame)\n\tUIScreen.bounds \(UIScreen.main.bounds)\n\tMain frame \(mainView.frame)\n\tMainFram MaxY \(mainView.frame.maxY)\n\tCoveredFrame \(coveredFrame)\n\tOwningViewFrame \(owningViewFrame)\n\tKeyboard top \(keybTop) - field bottom \(fieldBottom) = \(keybTop - fieldBottom)\n\t Is keyboard attached? \(keyboardInfo.isAttached)")
        
        if keybTop > 0 /*&& diff < 0*/ && keyboardInfo.endFrame.width > 300 {
            print("UP")
            keyboardInfo.animateAlongsideKeyboard { [unowned self] in
                if keyboardInfo.isAttached {
                    self.bottomConstraint.constant = -coveredFrame.height// -keyboardInfo.endFrame.height + bottomSafeY// -coveredFrame.height + bottomSafeY// -(keybTop - fieldBottom)
                } else {
                    self.bottomConstraint.constant = 0
                }
                //owningView.layoutIfNeeded()
            }
        } else {
            print("DOWN")
            keyboardInfo.animateAlongsideKeyboard { [unowned self] in
                self.bottomConstraint.constant = 0
                //owningView.layoutIfNeeded()
            }
            
        }
    }
    
    func keyboardFrameChanged(_ notification: Notification) {
        let owningView: UIView = self.parentView
        //guard let owningView = self.topGuide.owningView else { return }
        guard let window = owningView.window else { return }
        guard let keyboardInfo = KeyboardInfo(userInfo: notification.userInfo),
              keyboardInfo.endFrame != prevKeyboardFrame
        else { return }
        
        prevKeyboardFrame = keyboardInfo.endFrame
        
        var owningViewFrame = window.convert(owningView.frame, from: owningView.superview)
        owningViewFrame.origin.x = 0
        var coveredFrame = owningViewFrame.intersection(keyboardInfo.endFrame)
        coveredFrame = window.convert(coveredFrame, to: owningView.superview)
        
        let bottomSafeY = owningView.superview!.safeAreaInsets.bottom
        let keybTop = window.frame.height - keyboardInfo.endFrame.minY
//        let keybBottom = window.frame.height - keyboardInfo.endFrame.maxY
//        let fieldTop = window.frame.height - parentView.frame.maxY + 44
//        let fieldBottom = window.frame.height - parentView.frame.maxY
//        let diff = keybBottom - fieldTop
//        print("keyboardFrameChanged. keyboard frame \(keyboardInfo.endFrame)\n\twindow.frame \(window.frame)\n\tUIScreen.bounds \(UIScreen.main.bounds)\n\tMain frame \(parentView.frame)\n\tMainFram MaxY \(parentView.frame.maxY)\n\tCoveredFrame \(coveredFrame)\n\tOwningViewFrame \(owningViewFrame)\n\tKeyboard top \(keybTop) - field bottom \(fieldBottom) = \(keybTop - fieldBottom)\n\t Is keyboard attached? \(keyboardInfo.isAttached)")
        
        if keybTop > 0 /*&& diff < 0*/ && keyboardInfo.endFrame.width > 300 {
            keyboardInfo.animateAlongsideKeyboard { [unowned self] in
                if keyboardInfo.isAttached {
                    self.bottomConstraint.constant = -keyboardInfo.endFrame.height + bottomSafeY// -coveredFrame.height + bottomSafeY// -(keybTop - fieldBottom)
                } else {
                    self.bottomConstraint.constant = 0
                }
                //owningView.superview?.layoutIfNeeded()
            }
        } else {
            keyboardInfo.animateAlongsideKeyboard { [unowned self] in
                self.bottomConstraint.constant = 0
                //owningView.layoutIfNeeded()
            }
            
        }
    }

    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardInfo = KeyboardInfo(userInfo: notification.userInfo) else { return }
        //print("keyboardWillShow. keyboard frame \(keyboardInfo.endFrame)")
        keyboardFrameChanged(notification)
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        guard let keyboardInfo = KeyboardInfo(userInfo: notification.userInfo) else { return }
        //print("keyboardWillHide. keyboard frame \(keyboardInfo.endFrame)")
        keyboardInfo.animateAlongsideKeyboard { [weak self] in
            self?.bottomConstraint.constant = 0
        }
    }
}

@MainActor
struct KeyboardInfo {
    
    let endFrame: CGRect
    let animationOptions: UIView.AnimationOptions
    let animationDuration: TimeInterval
    
    init?(userInfo: [AnyHashable: Any]?) {
        guard let userInfo = userInfo else { return nil }
        guard let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return nil }
        
        self.endFrame = endFrame
        
        // UIViewAnimationOption is shifted by 16 bit from UIViewAnimationCurve, which we get here:
        // http://stackoverflow.com/questions/18870447/how-to-use-the-default-ios7-uianimation-curve
        if let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            self.animationOptions = UIView.AnimationOptions(rawValue: animationCurve << 16)
        } else {
            self.animationOptions = .curveEaseInOut
        }
        
        if let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            self.animationDuration = animationDuration
        } else {
            self.animationDuration = 0.25
        }
    }
    
    func animateAlongsideKeyboard(_ animations: @escaping () -> Void) {
        UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: self.animationOptions, animations: animations)
    }
    
    var isAttached: Bool {
        let screenBounds = UIScreen.main.bounds
        let attached = screenBounds.maxX == endFrame.maxX && screenBounds.maxY == endFrame.maxY && screenBounds.width == endFrame.width
        return attached
    }
}
