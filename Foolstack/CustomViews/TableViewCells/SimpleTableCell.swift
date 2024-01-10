//
//  SimpleTableCell.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import UIKit
import Combine

class SimpleTableCell : UITableViewCell {
    static let CellID = "SimpleTableCell"
    
    var titleLabel: UILabel!
    var leftIcon: UIImageView!
    var rightIcon: UIImageView!
    var sidePadding: CGFloat = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier:String?)
    {
        super.init(style:style, reuseIdentifier: reuseIdentifier);
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    //  deinit {
    //    print("DEINIT. SwipeTableCell")
    //  }
    
    // MARK: CREATE
    
    func initialize() {
        createContent()
        createSubContent()
    }
    
    func createSubContent() {}
    
    private func createContent()
    {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        leftIcon = UIImageView()
        //contentView.addSubview(leftIcon)
        //leftIcon.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.contentMode = .center
        //leftIcon.tintColor = UIColor.themeStandartIcon
        
        stackView.addArrangedSubview(leftIcon)
        
//        NSLayoutConstraint.activate([
//            leftIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
//            leftIcon.topAnchor.constraint(equalTo: contentView.topAnchor),
//            leftIcon.widthAnchor.constraint(equalToConstant: .buttonSize),
//            leftIcon.heightAnchor.constraint(equalToConstant: .buttonSize)
//        ])
        
        titleLabel = UILabel()
        //contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: .fontMainSize)// UIFont(name: .fontSFSemibold, size: .fontMainSize)
        titleLabel.textColor = .themeTextMain
        //titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        
        let heightConstr: NSLayoutConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: .buttonSize)
        heightConstr.priority = .defaultHigh
        let bottomConstr = contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        bottomConstr.priority = .defaultLow
        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .buttonSize + sidePadding),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.buttonSize - sidePadding),
//            bottomConstr,
//            heightConstr
//        ])
        
        rightIcon = UIImageView()
        //contentView.addSubview(rightIcon)
        //rightIcon.translatesAutoresizingMaskIntoConstraints = false
        rightIcon.contentMode = .center
        //rightIcon.tintColor = UIColor.themeStandartIcon
//        rightIcon.addTarget(self, action: #selector(rightIconPressed), for: .touchUpInside)
        
        stackView.addArrangedSubview(rightIcon)
        
//        NSLayoutConstraint.activate([
//            rightIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
//            rightIcon.topAnchor.constraint(equalTo: contentView.topAnchor),
//            rightIcon.widthAnchor.constraint(equalToConstant: .buttonSize),
//            rightIcon.heightAnchor.constraint(equalToConstant: .buttonSize)
//        ])
        
    }
    
    @objc func rightIconPressed(_ sender: UIButton) {
        print("Right icon pressed")
    }
    
    func configure(leftImage: IconNames, title: String) {
        leftIcon.image = .symbolImage(leftImage)
        titleLabel.text = title
    }
    
}
