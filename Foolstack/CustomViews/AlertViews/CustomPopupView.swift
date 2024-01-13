//
//  ConfirmationPopup.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

class CustomPopupView: UIView {
    var config: PopupConfiguration!
    var popupTransformer: PopupTransformer?
    var closeAction: ((CustomPopupView, CloseAction?) -> Void)?
    var topConstr: NSLayoutConstraint?
    private var popupTransition: PopupTransition!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(config: PopupConfiguration) {
        super.init(frame:.zero)
        self.config = config
        
        createContent()
    }
    
    deinit {
        print("DEINIT. ConfirmationPopup")
    }
    
    func createContent() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let mainView = UIView()
        self.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .themeBackgroundMain
        mainView.layer.cornerRadius = 12
        mainView.layer.shadowColor = UIColor.themeShadow1.cgColor
        mainView.layer.shadowOpacity = .shadowOpacity
        mainView.layer.shadowRadius = 16
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: self.topAnchor)
        ])

        let headerBar = HeaderBar(withSlider: false)
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(headerBar)
        headerBar.color = .themeHeader
        headerBar.heightConstraint.constant = 44
        headerBar.pinEdges(to: mainView, leading: 4, trailing: -4, top: 4)
        headerBar.titleLabel.text = config.title
        
        let contentView = UIView()
        mainView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: headerBar.bottomAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        var yAnchor: NSLayoutYAxisAnchor = contentView.bottomAnchor

        if let popupTextConfig = config as? PopupTextConfiguration {
            let label = createContentLabel(config: popupTextConfig)
            contentView.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .cellSideEdge),
                label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .cellSideEdge),
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .cellSideEdge),
                contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: .cellSideEdge)
            ])
        }
        
        if let buttonConfig = config as? PopupButtonsConfiguration {
            let buttonsView = PopupButtonsView(configs: buttonConfig.buttons)
            buttonsView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(buttonsView)
            NSLayoutConstraint.activate([
                buttonsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                buttonsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
                buttonsView.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 8)
            ])
            yAnchor = buttonsView.bottomAnchor
            
            buttonsView.onPress = { [weak self] needClose, closedAction in
                self?.buttonPressed(needClose: needClose, closedAction: closedAction)
            }
        }
        
        self.bottomAnchor.constraint(equalTo: yAnchor).isActive = true
    }
    
    private func createContentLabel(config: PopupTextConfiguration) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = CustomFonts.defaultMedium(size: config.textFontSize)
        label.textAlignment = config.textAlignment
        label.textColor = config.textColor
        label.text = config.text
        return label
    }
    
    private func buttonPressed(needClose: Bool, closedAction: CloseAction?) {
        if needClose {
            self.closeAction?(self, closedAction)
        }
    }
    
    private func onConfirm() {
//        confirmAction?()
//        confirmAction = nil
        closeView()
    }
    
    private func onCancel() {
//        cancelAction?()
//        cancelAction = nil
        closeView()
    }
    
//    override func show(safeInsets: UIEdgeInsets = .zero, animated: Bool = true) {
//        
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: { [weak self] in
//            guard let self = self, let parent = self.superview else {
//                return
//            }
//            let parentSafeInsets = parent.safeAreaInsets
//            let parentFrame = parent.frame.inset(by: parentSafeInsets)
//            let isRegular = self.isRegular
//            var bottomOffsetY = max(parentSafeInsets.bottom, .viewPadding)
//            if isRegular {
//                bottomOffsetY = (parentFrame.height - self.frame.height) * 0.5
//            }
//            
//            //print("Show ConfirmationPopup. Offset \(bottomOffsetY), parent safeInsets \(parent.safeAreaInsets.bottom)")
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
//                if let self = self, let constr = self.topConstr {
//                    if isRegular {
//                        //constr.constant =
//                    }
//                    //          print("Show OneTextFieldView 2. offset \(-self.frame.height - bottomOffsetY)")
//                    constr.constant = -self.frame.height - bottomOffsetY
//                    self.superview?.layoutIfNeeded()
//                }
//            }, completion: nil)
//        })
//    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        //print("Popup will move")
        if newSuperview == nil {
            //print("Popup will removed")
        } else {
        }
    }
    
    override func didMoveToSuperview() {
        if superview != nil {
            popupTransition = PopupTransition(popupView: self, position: .center, appearDirection: .bottom)
        }
    }
    
    func closeView() {
        //print("PopupViewBase closeView")
        closeAction?(self, nil)
        closeAction = nil
    }
    
    func show(safeInsets: UIEdgeInsets = .zero, animated: Bool = true) {
        if let transformer = popupTransition {
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
        if let transformer = popupTransition {
            transformer.hide(animated: animated, completion: completion)
        } else {
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
