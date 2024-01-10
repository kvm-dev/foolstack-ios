//
//  WikiListCell.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 06.01.2024.
//

import Foundation
import UIKit

struct WikiListCellConfiguration: UIContentConfiguration, Hashable {
    var text: String?
    var textColor: UIColor?
    var textFont: UIFont?
    var buttonTitle: String?
    var buttonTitleColor: UIColor?
    var buttonTitleFont: UIFont?
    
    func makeContentView() -> UIView & UIContentView {
        WikiListContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> WikiListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }
        var updatedConfiguration = self
        if state.isSelected {
            //current state not using
        }
        updatedConfiguration.textFont = CustomFonts.defaultRegular(size: 14)
        updatedConfiguration.textColor = .themeTextMain
        updatedConfiguration.buttonTitleFont = CustomFonts.defaultMedium(size: 12)
        updatedConfiguration.buttonTitleColor = .themeAccent
        
        return updatedConfiguration
    }
}

class WikiListContentView: UIView, UIContentView {
    let textLabel = UILabel()
    let buttonlabel = UILabel()
    
    init(configuration: WikiListCellConfiguration) {
        super.init(frame: .zero)
        setupView()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var currentConfiguration: WikiListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfig = newValue as? WikiListCellConfiguration else {
                return
            }
            
            apply(configuration: newConfig)
        }
    }
    
    private func setupView() {
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 24),
            textLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: 0),
            textLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 0),
        ])

        addSubview(buttonlabel)
        buttonlabel.translatesAutoresizingMaskIntoConstraints = false
        buttonlabel.numberOfLines = 1
        buttonlabel.text = String(localized: "Details...", comment: "")
        
        NSLayoutConstraint.activate([
            buttonlabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -12),
            buttonlabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 0),
            buttonlabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0)
        ])
        
    }
    
    private func apply(configuration: WikiListCellConfiguration) {
        if currentConfiguration == configuration {
            return
        }
        
        self.currentConfiguration = configuration
        
        textLabel.text = configuration.text
        textLabel.textColor = configuration.textColor
        textLabel.font = configuration.textFont
        
        buttonlabel.text = configuration.buttonTitle
        buttonlabel.textColor = configuration.buttonTitleColor
        buttonlabel.font = configuration.buttonTitleFont
    }
}



class WikiListCell: UICollectionViewCell {
    var text: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfig = WikiListCellConfiguration().updated(for: state)
        
        newConfig.text = self.text
        newConfig.buttonTitle = String(localized: "Detailed", comment: "")
        
        contentConfiguration = newConfig
    }
}
