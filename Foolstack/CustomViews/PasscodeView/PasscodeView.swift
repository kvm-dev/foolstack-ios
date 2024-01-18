//
//  PasscodeView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 17.01.2024.
//

import UIKit

enum PasskodeKeyboardType {
    case symbols
    case digits
}

@MainActor
class PasscodeView: UIView {
    var text: String?
    var maxLength = 4
    var keyboardType: UIKeyboardType = .numberPad
    let stack = UIStackView()
    
    init(length: Int) {
        super.init(frame: .zero)
        self.maxLength = length
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualTo: stack.heightAnchor),
            self.widthAnchor.constraint(greaterThanOrEqualTo: stack.widthAnchor),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        for _ in 0..<maxLength {
            let pin = PinView(frame: .zero)
            stack.addArrangedSubview(pin)
        }
        
        //updateStack(by: code)
    }
    
    func configView(labelFont: UIFont, labelColor: UIColor, cornerRadius: CGFloat = 0, pinColor: UIColor, pinBorderColor: UIColor? = nil, pinBorderWidth: CGFloat = 0) {
        let pins = stack.arrangedSubviews.compactMap{$0 as? PinView}
        pins.forEach { pin in
            pin.label.font = labelFont
            pin.label.textColor = labelColor
            pin.backgroundColor = pinColor
            pin.borderColor = pinBorderColor
            pin.layer.borderWidth = pinBorderWidth
            pin.layer.cornerRadius = cornerRadius
        }
    }
    
    func setPinSize(_ size: CGSize, spacing: CGFloat) {
        stack.spacing = spacing
        stack.arrangedSubviews.forEach {
            $0.pinSize(width: size.width, height: size.height)
        }
    }
    
    func updateStack() {
        guard let text = self.text else {
            return
        }
        let pins = stack.arrangedSubviews.compactMap{$0 as? PinView}
        pins.forEach { $0.label.text = nil }
        for (index, char) in text.prefix(pins.count).enumerated() {
            let pin = pins[index]
            pin.label.text = "\(char)"
        }
    }
}


extension PasscodeView {
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func showKeyboardIfNeed() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        addGestureRecognizer(gesture)
    }
    
    @objc private func showKeyboard() {
        becomeFirstResponder()
    }
    
}

extension PasscodeView: UIKeyInput {
    var hasText: Bool {
        return text != nil && !text!.isEmpty
    }
    
    func insertText(_ text: String) {
        var code = self.text ?? ""
        if code.count >= maxLength {
            return
        }
        code.append(contentsOf: text.prefix(maxLength - code.count))
        self.text = code
        print("Insert text '\(text)'. Code = '\(code)'")
        
        updateStack()
    }
    
    func deleteBackward() {
        if hasText {
            text?.removeLast()
            updateStack()
        }
        print("DeleteBackward'. Code = '\(text)'")
    }
}


extension PasscodeView: TextInputField {
    
    var attributedPlaceholder: NSAttributedString? {
        get {
            return nil
        }
        set {
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
    }
    
    
}



fileprivate class PinView: UIView {
    let label = UILabel()
    var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(label)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.pinEdges(to: self, padding: 10)
    }
    
}
