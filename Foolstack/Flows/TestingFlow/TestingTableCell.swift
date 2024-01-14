//
//  TestingTableCell.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 09.01.2024.
//

import Foundation
import UIKit

class TestingTableCell: UITableViewCell {
    static let CellID = "TestingTableCell"
    
    var title1Label: UILabel!
    var subtitle1Label: UILabel!
    var subtitle2Label: UILabel!
    var title2Label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //    super.traitCollectionDidChange(previousTraitCollection)
    //
    //    contentView.layer.borderColor = UIColor.themeBackgroundPopup.cgColor
    //  }
    
    private func createContent() {
        contentView.backgroundColor = nil
        selectionStyle = .none
        //    contentView.layer.borderWidth = 4
        //    contentView.layer.borderColor = UIColor.themeBackgroundPopup.cgColor
        //    contentView.layer.cornerRadius = 12
        //contentView.layer.backgroundColor = UIColor.themeCellBorder.cgColor
        
        let bgrdView = UIView()
        bgrdView.backgroundColor = .themeTestingCell1
        bgrdView.layer.cornerRadius = 20
        contentView.addSubview(bgrdView)
        bgrdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgrdView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bgrdView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bgrdView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bgrdView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        title2Label = UILabel()
        contentView.addSubview(title2Label)
        title2Label.numberOfLines = 0
        title2Label.font = CustomFonts.defaultBold(size: 16)
        title2Label.textColor = .themeTextMain
        title2Label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title2Label.topAnchor.constraint(equalTo: bgrdView.topAnchor, constant: .cellSideEdge),
            title2Label.trailingAnchor.constraint(equalTo: bgrdView.trailingAnchor, constant: -.cellSideEdge),
        ])
        
        title1Label = UILabel()
        contentView.addSubview(title1Label)
        title1Label.numberOfLines = 0
        title1Label.font = CustomFonts.defaultBold(size: 16)
        title1Label.textColor = .themeTextMain
        title1Label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title1Label.topAnchor.constraint(equalTo: bgrdView.topAnchor, constant: .cellSideEdge),
            title1Label.leadingAnchor.constraint(equalTo: bgrdView.leadingAnchor, constant: .cellSideEdge),
            title1Label.trailingAnchor.constraint(equalTo: bgrdView.trailingAnchor, constant: -30),
        ])
        
        subtitle1Label = UILabel()
        contentView.addSubview(subtitle1Label)
        subtitle1Label.numberOfLines = 1
        subtitle1Label.font = CustomFonts.defaultRegular(size: 13)
        subtitle1Label.textColor = .themeTextMainAlpha50
        subtitle1Label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subtitle1Label.topAnchor.constraint(equalTo: title1Label.bottomAnchor, constant: 5),
            subtitle1Label.leadingAnchor.constraint(equalTo: title1Label.leadingAnchor, constant: 0),
            bgrdView.bottomAnchor.constraint(equalTo: subtitle1Label.bottomAnchor, constant: .cellSideEdge),
        ])
        
        subtitle2Label = UILabel()
        contentView.addSubview(subtitle2Label)
        subtitle2Label.numberOfLines = 1
        subtitle2Label.font = CustomFonts.defaultRegular(size: 13)
        subtitle2Label.textColor = .themeTextMainAlpha50
        subtitle2Label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subtitle2Label.topAnchor.constraint(equalTo: subtitle1Label.topAnchor, constant: 0),
            subtitle2Label.trailingAnchor.constraint(equalTo: title2Label.trailingAnchor, constant: 0),
        ])
        
        contentView.bottomAnchor.constraint(equalTo: bgrdView.bottomAnchor, constant: 8).isActive = true
        
//        let rightIcon = UIButton()
//        contentView.addSubview(rightIcon)
//        rightIcon.translatesAutoresizingMaskIntoConstraints = false
//        rightIcon.contentMode = .center
//        rightIcon.setImage(.symbolImage(.sound), for: .normal)
//        rightIcon.tintColor = UIColor.themeStandartIcon
//        rightIcon.addTarget(self, action: #selector(rightIconPressed), for: .touchUpInside)
//        
//        NSLayoutConstraint.activate([
//            rightIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            rightIcon.topAnchor.constraint(equalTo: contentView.topAnchor),
//            rightIcon.widthAnchor.constraint(equalToConstant: .buttonSize),
//            rightIcon.heightAnchor.constraint(equalToConstant: .buttonSize)
//        ])
        
    }
    
    func configure(title1: String, title2: String, subtitle1: String, subtitle2: String) {
        title1Label.text = title1
        title2Label.text = title2
        subtitle1Label.text = subtitle1
        subtitle2Label.text = subtitle2
    }
    
}

