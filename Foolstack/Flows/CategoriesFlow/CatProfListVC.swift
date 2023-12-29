//
//  CatProfListVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 29.12.2023.
//

import Foundation
import UIKit

@MainActor
final class CatProfListVC : UIViewController, CatListView {
    
    var presenter: CatListPresenter!
    
    var headerBar: UIView!
    
    //    init(presenter: WikiListPresenter) {
    //        self.presenter = presenter
    //
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHeader()
        createView()
//        self.navigationController?.isNavigationBarHidden = true

        presenter.viewDidLoad(view: self)
    }
    
    func show(items: [CatEntity]) {
        
    }
    
    private func createView() {
        self.view.backgroundColor = .themeBackgroundTop
        
        let v = UIView()
        self.view.addSubview(v)
        v.backgroundColor = .themeBackgroundMain
        v.clipsToBounds = true
        v.layer.cornerRadius = 32
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          v.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
          v.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
          v.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
          v.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .orange

        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        let mainImage = UIImageView()
        self.view.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.contentMode = .center
        mainImage.image = UIImage(named: "prof_main")
        mainImage.backgroundColor = .yellow
        
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: self.headerBar.bottomAnchor, constant: 30),
            mainImage.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -30),
            mainImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mainImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        ])

    }
    
    private func createHeader() {
      headerBar = UIView()//HeaderBar(withSlider: false)
      headerBar.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(headerBar)
      //headerBar.headerView.backgroundColor = .themeBackgroundMain
      headerBar.pinEdges(to: view, leading: 8, trailing: -8, top: 0)
      //headerBar.titleLabel.text = NSLocalizedString("Term", comment: "")

//      let closeButton = UIButton.customClose()
//      headerBar.addLeftButton(button: closeButton)
//      closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
      
    }
}
