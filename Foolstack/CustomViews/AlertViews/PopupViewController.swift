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
    private weak var currentPopup: CustomPopupView?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        print("PopupViewController deinit")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.themeOverlay
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnBackView(recognizer:)))
        view.addGestureRecognizer(singleFingerTap)
        
        if popupConfigs.count > 0 {
            showNextView()
        }
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
        popupView.show(animated: true)
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
            popupConfigs.removeAll()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

