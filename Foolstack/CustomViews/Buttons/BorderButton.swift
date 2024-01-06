//
//  BorderButton.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 30.12.2023.
//

import UIKit

class BorderButton: UIButton {
    @IBInspectable var padding: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet {
            self.setNeedsDisplay()
            //layer.cornerRadius = cornerRadius - borderWidth
        }
    }
    
    @IBInspectable var color: UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    convenience init(backgroundColor: UIColor?, borderColor: UIColor? = nil, borderWidth: CGFloat = 0, padding: CGFloat = 0) {
        self.init(type: .custom)
        self.color = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.padding = padding
        self.backgroundColor = nil
        //updateBorder()
        
        //    layer.cornerRadius = cornerRadius + borderWidth
        setTitleColor(.themeTextMain, for: .normal)
        titleLabel?.font = CustomFonts.defaultSemiBold(size: .fontMainSize)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = nil
    }
    
    //  required init?(coder: NSCoder) {
    //    super.init(coder: coder)
    //    self.backgroundColor = nil
    //  }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //updateBorder()
    }
    
    func updateBorder() {
        if let borderColor = self.borderColor {
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth * 0.5 + padding, dy: borderWidth * 0.5 + padding), cornerRadius: cornerRadius)//cornerRadius - borderWidth)
        path.lineWidth = borderWidth
        if let borderColor = borderColor {
            borderColor.setStroke()
            path.stroke()
        }
        if let color = color {
            let clr = isEnabled ? color : color.withAlphaComponent(0.5)
            clr.setFill()
            path.fill()
        }
    }
}
