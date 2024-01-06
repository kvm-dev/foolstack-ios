//
//  CatProfCell.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 30.12.2023.
//

import Foundation
import UIKit

class CatProfCell: UICollectionViewCell {
    static let reuseIdentifier = "CatProfCell"
    
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var imageView: WebImageView!
    
    var index = 0
    var onAction: ((Int) -> Void)?
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.backgroundColor = nil//UIColor.green
      createContent()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    private func createContent() {
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = CustomFonts.defaultBold(size: .fontMainSize)
        titleLabel.textColor = .themeTextMain
        titleLabel.numberOfLines = 0
        
        titleLabel.pinEdges(to: contentView, leading: 24, trailing: -24, top: 8)
        
        let commonView = UIView()
        contentView.addSubview(commonView)
        commonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            commonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            commonView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            commonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        commonView.layer.cornerRadius = 32
        commonView.layer.borderWidth = 2
        commonView.layer.borderColor = UIColor.themeStandartIcon.cgColor

        descriptionLabel = UILabel()
        commonView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = CustomFonts.defaultMedium(size: 13)
        descriptionLabel.textColor = .themeTextSecondary
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        
        let padding: CGFloat = 14
        
        descriptionLabel.pinEdges(to: commonView, leading: padding, trailing: -padding, top: padding)
        
        let button = BorderButton(backgroundColor: .themeAccent)
        commonView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Choice", comment: ""), for: .normal)
        button.pinEdges(to: commonView, leading: padding, trailing: -padding, bottom: -padding)
        button.pinSize(height: 56)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        imageView = WebImageView()
        commonView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: commonView.leftAnchor, constant: padding),
            imageView.rightAnchor.constraint(equalTo: commonView.rightAnchor, constant: -padding),
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            imageView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -30)
        ])
        imageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        
    }
    
    func configure(title: String, description: String, imagePath: String?, index: Int) {
        self.index = index
        titleLabel.text = title
        descriptionLabel.text = description
        
        if let imagePath = imagePath {
            imageView.load(urlString: imagePath, folder: "professions")
        }
        self.contentView.layoutIfNeeded()
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        onAction?(index)
    }
}
