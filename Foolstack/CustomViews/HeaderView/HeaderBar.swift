//
//  HeaderBar.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import UIKit
import Combine

@IBDesignable
class HeaderBar: UIView {
    var leftButtonStack: UIStackView!
    var rightButtonStack: UIStackView!
    var titleLabel: UILabel!
    var headerView: UIView!
    var sliderView: UIView!
    var heightConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    
    @IBInspectable var color: UIColor = .yellow {//}.themeBackgroundSecondary {
        didSet {
            headerView.backgroundColor = color
        }
    }
    @IBInspectable var withSlider: Bool = false {
        didSet {
            sliderView.isHidden = !withSlider
            topConstraint.constant = withSlider ? 8 : 0
        }
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    /// - Parameters:
    ///   - withSlider: Short line on top (no interactive)
    ///   - onPopup: For color selection
    init(withSlider: Bool) {
        self.withSlider = withSlider
        super.init(frame: .zero)
        initialize()
        sliderView.isHidden = !withSlider
        topConstraint.constant = withSlider ? 8 : 0
        color = .blue// onPopup ? .themeHeaderPopup : .themeHeaderMain
    }
    
    private func initialize() {
        //self.backgroundColor = .blue
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        sliderView = UIView()
        self.addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            sliderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            sliderView.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            sliderView.widthAnchor.constraint(equalToConstant: 32),
            sliderView.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        headerView = UIView()
        self.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
        ])
        
        topConstraint = headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        heightConstraint = headerView.heightAnchor.constraint(equalToConstant: 50)
        topConstraint.isActive = true
        heightConstraint.isActive = true
        
        self.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        leftButtonStack = UIStackView()
        headerView.addSubview(leftButtonStack)
        leftButtonStack.translatesAutoresizingMaskIntoConstraints = false
        leftButtonStack.axis = .horizontal
        leftButtonStack.alignment = .fill
        leftButtonStack.distribution = .fill
        
        NSLayoutConstraint.activate([
            leftButtonStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            leftButtonStack.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            //leftButtonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        rightButtonStack = UIStackView()
        headerView.addSubview(rightButtonStack)
        rightButtonStack.translatesAutoresizingMaskIntoConstraints = false
        rightButtonStack.axis = .horizontal
        rightButtonStack.alignment = .fill
        rightButtonStack.distribution = .fill
        
        NSLayoutConstraint.activate([
            rightButtonStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            rightButtonStack.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            //rightButtonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        titleLabel = UILabel()
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: .fontMainSize)// UIFont(name: .fontSFSemibold, size: .fontMainSize)
        titleLabel.textColor = .themeTextMain
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leftButtonStack.trailingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightButtonStack.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        let titleXConstr = titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        titleXConstr.priority = .defaultLow
        titleXConstr.isActive = true
        
        headerView.layer.cornerRadius = 8
        sliderView.layer.cornerRadius = 2
        headerView.backgroundColor = color
    }
    
    func addLeftButton(button: UIButton) {
        leftButtonStack.addArrangedSubview(button)
    }
    
    func addRightButton(button: UIButton) {
        rightButtonStack.insertArrangedSubview(button, at: 0)
    }
}

