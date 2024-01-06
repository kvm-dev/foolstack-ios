//
//  TagListCell.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 05.01.2024.
//

import Foundation
import UIKit

class TagListCell: UICollectionViewCell {
    static let reuseIdentifier = "TagListCell"
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.backgroundColor = nil//UIColor.green
      createContent()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    private func createContent() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = CustomFonts.defaultRegular(size: .fontMainSize)
        titleLabel.textColor = .themeTextMain
        titleLabel.numberOfLines = 1
        
        titleLabel.pinEdges(to: contentView, leading: 10, trailing: -10, centerY: 0)
        
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            contentView.backgroundColor = .themeAccent
            contentView.layer.borderWidth = 0
            titleLabel.textColor = .themeTextMain
        } else {
            contentView.backgroundColor = .themeBackgroundMain
            contentView.layer.borderWidth = 1
            titleLabel.textColor = .themeTextSecondary
        }
    }
}
