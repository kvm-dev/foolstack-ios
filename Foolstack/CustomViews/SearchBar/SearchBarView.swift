//
//  SearchBarView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 07.01.2024.
//

import Combine
import UIKit

class SearchBarView: UIView {
    var searchBar: CustomTextField!
    weak var transitionView: UIView?
    @Published var searchText: String = ""
    
    var placeholder: String? {
        get {
            searchBar.attributedPlaceholder?.string
        }
        set {
            searchBar.attributedPlaceholder = newValue?.placeholderAttributed()
        }
    }
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //print("IndicatorView init coder. slider is nil?", slider == nil)
        initialize()
    }
    
    private func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGray
        self.layer.cornerRadius = 12
        
        searchBar = CustomTextField(backgroundColor: nil, borderColor: nil, borderWidth: 0, borderPadding: 0)
        addSubview(searchBar)
        searchBar.leftPadding = 48
        searchBar.rightPadding = 36
        searchBar.textColor = .themeTextMain
        //searchBar.cornerRadius = 12
        searchBar.clearButtonMode = .whileEditing
        searchBar.autocapitalizationType = .none
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        //searchBar.backgroundColor = .blue

//        if let clearButton = searchBar.value(forKeyPath: "_clearButton") as? UIButton {
//            //print("Clear button found")
//            clearButton.setImage(.symbolImage(.delete), for: .normal)
//            clearButton.tintColor = .themeTextSecondary
//        }
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let leftIcon = UIImageView(image: UIImage(named: "search.1"))
        addSubview(leftIcon)
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            leftIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            leftIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftIcon.widthAnchor.constraint(equalToConstant: 20),
            leftIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setVisible(_ visible: Bool) {
        if let secondView = transitionView {
            let viewToHide = visible ? secondView : self
            let viewToShow = visible ? self : secondView
            
            UIView.transition(from: viewToHide, to: viewToShow, duration: 0.3, options: [.showHideTransitionViews, .transitionCrossDissolve], completion: nil)
        } else {
            //      let viewToHide = visible ? nil : self
            //      let viewToShow = visible ? self : nil
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseIn],
                           animations: { [weak self] in
                if visible {
                    self?.isHidden = !visible
                }
                self?.alpha = visible ? 1 : 0
            }, completion: { [weak self] finished in
                if finished && !visible {
                    self?.isHidden = !visible
                }
            })
        }
        if visible {
            //searchButton.tintColor = UIColor.themeSpecialIcon
            searchBar.becomeFirstResponder()
        } else {
            //searchButton.tintColor = UIColor.themeStandartIcon
            searchBar.resignFirstResponder()
            searchText = ""
            searchBar.text = ""
        }
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.searchText = textField.text ?? ""
    }
}

extension SearchBarView: UITextFieldDelegate {
    //  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //    print("SearchBar shouldChange textView.text '\(textField.text)'")
    //    self.searchText = textField.text ?? ""
    //    return true
    //  }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
