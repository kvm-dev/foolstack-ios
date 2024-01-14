//
//  CatSpecCell.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 02.01.2024.
//

import Foundation
import UIKit

class CatSpecCell: UICollectionViewCell {
    static let reuseIdentifier = "CatSpecCell"
    
    var titleLabel: UILabel!
    var imageView: WebImageView!
    var toggleImage: UIImageView!
    
    var index = 0
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        self.backgroundColor = nil//.orange
      createContent()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    private func createContent() {
        let bgrdPadding: CGFloat = 8
        let bgrdView = UIView()
        contentView.addSubview(bgrdView)
        bgrdView.translatesAutoresizingMaskIntoConstraints = false
        bgrdView.pinEdges(to: contentView, padding: bgrdPadding)
        
        bgrdView.backgroundColor = .themeBackgroundMain
        bgrdView.layer.cornerRadius = 12
        bgrdView.layer.shadowRadius = 8
        bgrdView.layer.shadowOffset = .zero
        bgrdView.layer.shadowOpacity = 0.02
        //bgrdView.layer.shad
        bgrdView.layer.shadowColor = CGColor(red: 13/255.0, green: 21/255.0, blue: 38/255.0, alpha: 1)

        let padding: CGFloat = 12 + bgrdPadding
        let imageSize: CGFloat = 52

        let imageViewContainer = UIView()
        contentView.addSubview(imageViewContainer)
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            imageViewContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            imageViewContainer.widthAnchor.constraint(equalToConstant: imageSize),
            imageViewContainer.heightAnchor.constraint(equalToConstant: imageSize),
        ])

        imageView = WebImageView()
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
        ])

        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = CustomFonts.defaultSemiBold(size: 16)
        titleLabel.textColor = .themeTextMain
        titleLabel.numberOfLines = 0
        //titleLabel.backgroundColor = .green
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding + imageSize),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(padding + imageSize)),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            //titleLabel.heightAnchor.constraint(equalToConstant: 56),
        ])
//        let c1 = contentView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor)
//        c1.priority = .defaultHigh
//        c1.isActive = true
//        let c2 = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 52)
//        c2.priority = .defaultLow
//        c2.isActive = true


        let iconName = IconNames.checkboxIcon(checked: false)
        toggleImage = UIImageView(image: .symbolImage(iconName))
        toggleImage.isUserInteractionEnabled = false
        toggleImage.contentMode = .center
        toggleImage.tintColor = iconName.color
        toggleImage.tag = 111
        contentView.addSubview(toggleImage)
        toggleImage.translatesAutoresizingMaskIntoConstraints = false
        toggleImage.pinSize(width: .buttonSize, height: .buttonSize)
        toggleImage.pinEdges(to: contentView, trailing: -8, centerY: 0)
    }
    
    func configure(title: String, imagePath: String?, index: Int) {
        titleLabel.text = title
        self.index = index
        
        if let imagePath = imagePath {
            imageView.load(urlString: imagePath, folder: "professions")
        }
    }
    
    func setToggled(_ toggled: Bool) {
        let iconName = IconNames.checkboxIcon(checked: toggled)
        toggleImage.image = .symbolImage(iconName)
        toggleImage.tintColor = iconName.color
    }
}

