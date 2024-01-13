//
//  PopupButtonsView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

class PopupButtonsView: UIView {
    /// Parameter 1: Should dismiss
    /// Parameter 2: Action on dismiss finished
    var onPress: ((Bool, CloseAction?) -> Void)?
    weak var buttonsView: UIView!
    var buttonConfigs: [PopupButtonConfig] = []
    
    let path = UIBezierPath()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setFrameStyle()
        buttonsView.layer.borderColor = UIColor.themeBackgroundPopup.cgColor
    }
    
    init(configs: [PopupButtonConfig]) {
        super.init(frame: .zero)
        self.buttonConfigs = configs
        
        self.setFrameStyle()
        
        var buttons = [UIButton]()
        for buttonConfig in buttonConfigs {
            buttons.append(createButton(buttonConfig))
        }
        
        let buttonsView = UIStackView(arrangedSubviews: buttons)
        self.buttonsView = buttonsView
        addSubview(buttonsView)
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.axis = .horizontal
        buttonsView.distribution = .fillEqually
        let constraints = [
            buttonsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            buttonsView.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func createButton(_ buttonConfig: PopupButtonConfig) -> UIButton {
        let button1 = BorderButton(backgroundColor: .themeHeader, borderColor: .themeBackgroundMain, borderWidth: 8, padding: 0)
        button1.titleLabel?.font = CustomFonts.SFSemibold.font(size: .fontMainSize)
        button1.setTitle(buttonConfig.title, for: .normal)
        button1.setTitleColor(buttonConfig.style.normalTextColor, for: .normal)
        button1.setTitleColor(buttonConfig.style.disabledTextColor, for: .disabled)
        button1.addAction(UIAction(handler: { [weak self] action in
            let needHide = buttonConfig.action.onPress()
            self?.onPress?(needHide, buttonConfig.action.onDismissed)
        }), for: .touchUpInside)
        button1.heightAnchor.constraint(equalToConstant: 44).isActive = true

        return button1
    }
    
//    @objc private func buttonPressed(sender: UIButton) {
//        let tag = sender.tag
//        precondition(tag < buttonActions.count)
//        buttonActions[tag].action()
//    }
}

fileprivate class MyButton: UIButton {
    var roundType: RoundButtonType = .full
    var color: UIColor!
    
    init(frame: CGRect, type: RoundButtonType, color: UIColor) {
        super.init(frame: frame)
        self.adjustsImageWhenHighlighted = false
        roundType = type
        self.color = color
        setBackgroundImage(getBackgroundImage(), for: .normal)
        //    layer.borderWidth = 4
        //    layer.borderColor = UIColor.yellow.cgColor// UIColor.themeBackgroundPopup.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setBackgroundImage(getBackgroundImage(), for: .normal)
        //    layer.borderColor = UIColor.yellow.cgColor// UIColor.themeBackgroundPopup.cgColor
    }
    
    private func getBackgroundImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.addRect(CGRect(origin: .zero, size: frame.size))
            ctx.cgContext.drawPath(using: .fill)
        }
        return img
    }
    
    private func getRoundedImage(frame: CGRect, type: RoundButtonType) -> UIImage {
        let padding: CGFloat = 4
        let radius: CGFloat = 8
        
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        
        let img = renderer.image { ctx in
            var x = frame.size.width/2
            var y = padding
            //ctx.cgContext.setFillColor(UIColor(Color.themeBackgroundSecondary).cgColor)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            //      ctx.cgContext.addRect(CGRect(origin: .zero, size: frame.size))
            //      ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
            //      ctx.cgContext.setLineWidth(2)
            ctx.cgContext.move(to: CGPoint(x: x, y: y))
            if type.isRightRounded() {
                x = frame.size.width - padding - radius
                ctx.cgContext.addLine(to: CGPoint(x: x, y: y))
                y += radius
                ctx.cgContext.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: -.pi/2, endAngle: 0, clockwise: false)
                x += radius; y = frame.size.height - padding - radius
                ctx.cgContext.addLine(to: CGPoint(x: x, y: y))
                x -= radius
                ctx.cgContext.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: 0, endAngle: .pi/2, clockwise: false)
                x = 0; y += radius
            }
            else {
                x = frame.size.width
                ctx.cgContext.addLine(to: CGPoint(x: x, y: y))
                y = frame.size.height - padding
                ctx.cgContext.addLine(to: CGPoint(x: x, y: y))
                x = 0
            }
            if type.isLeftRounded() {
                x = padding + radius
                ctx.cgContext.addLine(to: CGPoint(x: x, y: y))
                y -= radius
                ctx.cgContext.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: .pi/2, endAngle: .pi, clockwise: false)
                x -= radius; y = padding + radius
                ctx.cgContext.addLine(to: CGPoint(x: x, y: y))
                x += radius
                ctx.cgContext.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: .pi, endAngle: -.pi/2, clockwise: false)
            }
            else {
                ctx.cgContext.addLine(to: CGPoint(x: x, y: y))
                y = padding
                ctx.cgContext.addLine(to: CGPoint(x: x, y: y))
            }
            ctx.cgContext.closePath()
            ctx.cgContext.drawPath(using: .fill)
        }
        return img
    }
    
    enum RoundButtonType {
        case left
        case center
        case right
        case full;
        
        func isRightRounded() -> Bool {
            return self == .right || self == .full
        }
        func isLeftRounded() -> Bool {
            return self == .left || self == .full
        }
        
        private var padding: CGFloat { 4 }
        private var radius: CGFloat { 8 }
    }
    
}

struct PopupButtonStyle {
    let normalColor: UIColor
    let normalTextColor: UIColor
    let disabledColor: UIColor?
    let disabledTextColor: UIColor?
    
    init(normalColor: UIColor, normalTextColor: UIColor, disabledColor: UIColor? = nil, disabledTextColor: UIColor? = nil) {
        self.normalColor = normalColor
        self.normalTextColor = normalTextColor
        self.disabledColor = disabledColor
        self.disabledTextColor = disabledTextColor
    }
    
    static var common: PopupButtonStyle {
        PopupButtonStyle(normalColor: .themeBackgroundSecondary, normalTextColor: .themeTextMain, disabledColor: nil, disabledTextColor: .themeTextDisabled)
    }
}

struct PopupButtonConfig {
    //let id = UUID()
    let title: String
    let style: PopupButtonStyle
    //let action: () -> (() -> Void)?
    let action: PopupButtonAction
}

struct PopupButtonAction {
    let onPress: () -> Bool
    let onDismissed: (() -> Void)?
    
    init(onPress: (() -> Bool)? = nil, onDismissed: (() -> Void)? = nil) {
        self.onPress = onPress ?? { return true }
        self.onDismissed = onDismissed
    }
}
