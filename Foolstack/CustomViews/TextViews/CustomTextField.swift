//
//  CustomTextField.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 07.01.2024.
//

import UIKit

struct TextAction {
    let event: UIControl.Event
    let action: (String?) -> Void
}

class CustomTextField: UITextField {
    
    private var actions: [TextAction] = []
    
    var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.maxX - .buttonSize - borderPadding*0.0, y: bounds.midY - .buttonSize*0.5, width: .buttonSize, height: .buttonSize)
    }
    
    //  override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
    //    CGRect(bounds.maxX - 100, 0, 60, bounds.height)
    //  }
    //  override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    //    CGRect(bounds.maxX - 100, 0, 60, bounds.height)
    //  }
    
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    
    @IBInspectable var borderPadding: CGFloat = 0
    
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            //layer.borderColor = self.borderColor?.cgColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0
    //  {
    //    didSet {
    //      layer.borderWidth = self.borderWidth
    //    }
    //  }
    
    @IBInspectable var color: UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0
    //  {
    //    didSet {
    //      layer.cornerRadius = self.cornerRadius
    //      layer.masksToBounds = self.cornerRadius > 0
    //    }
    //  }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init(backgroundColor: UIColor?, borderColor: UIColor? = nil, borderWidth: CGFloat = 4, borderPadding: CGFloat = 0) {
        self.init(frame: .zero)
        self.color = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.borderPadding = borderPadding
        //updateBorder()
        
        //    layer.cornerRadius = cornerRadius + borderWidth
        self.textColor = .themeTextMain
        self.font = CustomFonts.defaultRegular(size: 17)
        
        self.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    private func initialize() {
        self.borderStyle = .none
        self.backgroundColor = nil
//        if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
//            //print("Clear button found")
//            clearButton.setImage(.symbolImage(.delete), for: .normal)
//            clearButton.tintColor = .themeTextSecondary
//        }
    }
    
    /*override func draw(_ rect: CGRect) {
        super.draw(rect)
        //    self.layer.cornerRadius = self.cornerRadius
        //    self.layer.borderWidth = self.borderWidth
        //    self.layer.borderColor = self.borderColor?.cgColor
        
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth + borderPadding, dy: borderWidth + borderPadding), cornerRadius: cornerRadius)//cornerRadius - borderWidth)
        path.lineWidth = borderWidth
        if let borderColor = borderColor {
            borderColor.setStroke()
            path.stroke()
        }
        if let color = color {
            color.setFill()
            path.fill()
        }
    }*/
    
    @objc private func textChanged() {
        let acts = self.actions.filter { $0.event.contains(.editingChanged)}
        acts.forEach { $0.action(self.text) }
    }

    func addAction(_ action: @escaping (String?) -> Void, for controlEvents: UIControl.Event) {
        self.actions.append(TextAction(event: controlEvents, action: action))
    }

}


extension CustomTextField: TextInputField {}
