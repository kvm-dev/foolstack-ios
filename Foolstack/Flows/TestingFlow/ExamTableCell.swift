//
//  ExamTableCell.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 10.01.2024.
//

import Foundation
import UIKit

class ExamTableCell: UITableViewCell {
    static let reuseIdentifier = "ExamTableCell"
    
    var titleLabel: UILabel!
    private var toggleImage: UIImageView!
    private var borderView: UIView!
    private var bgrdView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createContent()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    private func createContent() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .themeBackgroundSecondary
        
        let bgrdPadding: CGFloat = 8
        bgrdView = UIView()
        contentView.addSubview(bgrdView)
        bgrdView.translatesAutoresizingMaskIntoConstraints = false
        bgrdView.pinEdges(to: contentView, leading: .cellSideEdge, trailing: -.cellSideEdge, top: bgrdPadding, bottom: -bgrdPadding)
        
        bgrdView.backgroundColor = .themeTestingCell2
        bgrdView.layer.cornerRadius = 12
        bgrdView.layer.shadowRadius = 8
        bgrdView.layer.shadowOffset = .zero
        bgrdView.layer.shadowOpacity = 0.02
        //bgrdView.layer.shad
        bgrdView.layer.shadowColor = CGColor(red: 13/255.0, green: 21/255.0, blue: 38/255.0, alpha: 1)
        
        borderView = UIView()
        contentView.addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .clear
        borderView.layer.cornerRadius = 15
        borderView.layer.borderColor = UIColor.themeBackgroundTop.cgColor
        borderView.layer.borderWidth = 2
        borderView.isHidden = true
        let borderPadding: CGFloat = 5
        borderView.pinEdges(to: bgrdView, padding: -borderPadding)

        let padding: CGFloat = 12 + .cellSideEdge

        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = CustomFonts.defaultSemiBold(size: 16)
        titleLabel.textColor = .themeTextMain
        titleLabel.numberOfLines = 0
        //titleLabel.backgroundColor = .green
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(padding)),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            //titleLabel.heightAnchor.constraint(equalToConstant: 56),
        ])
        let c1 = contentView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, constant: 48)
        c1.priority = .defaultHigh
        c1.isActive = true
        let c2 = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 52)
        c2.priority = .defaultLow
        c2.isActive = true


        let iconName = IconNames.checkboxIcon(checked: false)
        toggleImage = UIImageView(image: .symbolImage(iconName))
        toggleImage.isUserInteractionEnabled = false
        toggleImage.contentMode = .center
        toggleImage.tintColor = iconName.color
        contentView.addSubview(toggleImage)
        toggleImage.translatesAutoresizingMaskIntoConstraints = false
        toggleImage.pinSize(width: .buttonSize, height: .buttonSize)
        toggleImage.pinEdges(to: contentView, trailing: -.cellSideEdge, centerY: 0)
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func setToggled(_ toggled: Bool, isRadioButton: Bool) {
        borderView.isHidden = true
        bgrdView.backgroundColor = .themeTestingCell2

        let iconName: IconNames = isRadioButton ? IconNames.radioboxIcon(checked: toggled) : IconNames.checkboxIcon(checked: toggled)
        toggleImage.image = .symbolImage(iconName)
        toggleImage.tintColor = iconName.color
    }
    
    func showBorder() {
        borderView.isHidden = false
    }
    
    func highlight(isSuccess: Bool) {
        bgrdView.backgroundColor = isSuccess ? .themeStatGood : .themeStatBad
    }
}

