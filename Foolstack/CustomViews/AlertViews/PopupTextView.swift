//
//  PopupTextView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.01.2024.
//

import UIKit

class PopupTextView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, parentView: UIView) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor.themeTextMain
        titleLabel.font = CustomFonts.defaultMedium(size: .fontMainSize)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
