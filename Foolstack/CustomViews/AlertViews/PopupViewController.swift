//
//  PopupViewController.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

typealias CloseAction = () -> Void

class PopupViewController: UIViewController {
    
    var onDismissFinished: (() -> Void)?
    
    private var popupConfigs: [PopupConfiguration] = []
    private var popupViews: [CustomPopupView] = []
    private weak var currentPopup: CustomPopupView?
    //private var dismissAction: CloseAction?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        //print("MyTestViewController viewWillDisappear")
    }
    
    deinit {
        print("PopupViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("MyTestViewController viewDidLoad")
        
        //let frameView = OneTextFieldView(frame: view.frame, onConfirm: )
        
        //frameView.isHidden = true
        
        self.view.backgroundColor = UIColor.themeOverlay
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnBackView(recognizer:)))
        view.addGestureRecognizer(singleFingerTap)
        
        //    let backView = UIView(frame: view.bounds)
        //    backView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //    backView.backgroundColor = UIColor.themeOverlay
        //    //backView.alpha = 0.2
        //    view.addSubview(backView)
        //    backView.isHidden = true
        //
        //
        //    UIView.transition(with: backView, duration: 5, options: [.curveEaseOut, .transitionCurlUp], animations: {
        //      backView.isHidden = false
        //    }, completion: nil)
        
        if popupConfigs.count > 0 {
            showNextView()
        }
        
        //    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [weak self] in
        //      if let self = self, self.popupViews.count > 0 {
        //        self.showNextView()
        //      }
        //    }
        
        //    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
        //      UIView.animate(withDuration: 5, delay: 0, options: .curveEaseOut, animations: {
        //        //frameView.layer.position = CGPoint(x: padding, y: frameTo.maxY)
        //        frameView.frame = frameTo
        //      }) { _ in
        //      }
        //    })
        
        //    frameView.isHidden = true
        //    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
        //      UIView.transition(with: frameView, duration: 5, options: [.curveEaseOut, .transitionCurlUp], animations: {
        //        frameView.isHidden = false
        //      }, completion: nil)
        //
        //    })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //      UIView.transition(with: frameView, duration: 5, options: [.curveEaseOut, .transitionCurlUp], animations: {
        //        frameView.isHidden = false
        //      }, completion: nil)
        
        //      let insets = self.view.safeAreaInsets
        //      let frameTo: CGRect = .init(x: frameView.frame.origin.x, y: self.view.frame.height - frameView.frame.height - 10, width: frameView.frame.width, height: frameView.frame.height)
        //      var pos = frameView.layer.position
        //      pos.y -= frameView.frame.height + 10 + insets.bottom
        //
        //      UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
        //        frameView.layer.position = pos
        //        //frameView.frame = frameTo
        //      }) { _ in
        //      }
        
    }
    
    func addView(_ popupView: PopupConfiguration) {
        popupConfigs.append(popupView)
        //    if popupViews.count == 1 {
        //      showNextView()
        //    }
    }
    
    func showNextView() {
        if let nextView = popupConfigs.first {
            popupConfigs.removeFirst()
            let popup = CustomPopupView(config: nextView)
            view.addSubview(popup)
            popup.closeAction = { [weak self] popupView, action in
                self?.onCloseView(popupView: popupView, onDismissFinished: action)
            }
            showViewWithAnimation(popup)
            currentPopup = popup
        }
    }
    
    func showViewWithAnimation(_ popupView: CustomPopupView) {
        popupView.show(safeInsets: self.view.safeAreaInsets, animated: true)
    }
    
    func onCloseView(popupView: CustomPopupView, onDismissFinished: CloseAction?) {
        if popupConfigs.count > 0 {
            //showNextView()
            popupView.hide(animated: true, completion: { [weak self, weak popupView] in
                popupView?.removeFromSuperview()
                self?.showNextView()
            })
        } else {
            let disAction = onDismissFinished
            popupView.hide(animated: true, completion: { [weak self, weak popupView] in
                popupView?.removeFromSuperview()
                self?.dismiss(animated: true, completion: { [weak self, disAction] in
                    disAction?()
                    self?.onDismissFinished?()
                })
            })
        }
    }
    
    @objc func tapOnBackView(recognizer: UITapGestureRecognizer) {
        if let popupView = currentPopup {
            popupView.closeView()
        } else {
            popupViews.removeAll()
            popupConfigs.removeAll()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

