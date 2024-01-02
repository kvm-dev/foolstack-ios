//
//  CatListVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 28.12.2023.
//

import Foundation
import UIKit

@MainActor
final class CatListVC : UIViewController, CatListView {
    
    var presenter: CatListPresenter!
    
    var headerBar: HeaderBar!
    var profView: CatProfView!
    var specView: CatSpecView!
    
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
        createContent()
        
        profView.onAction = { [weak self] entity in self?.entitySelected(entity) }
        
        presenter.viewDidLoad(view: self)
    }
    
    private func createHeader() {
        headerBar = HeaderBar(withSlider: false)
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerBar)
        headerBar.color = .clear
        //headerBar.headerView.backgroundColor = .themeBackgroundMain
        //headerBar.pinEdges(to: view, leading: 8, trailing: -8, top: 0)
        headerBar.titleLabel.text = NSLocalizedString("Choice profession", comment: "")
        
        NSLayoutConstraint.activate([
            headerBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            headerBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            headerBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 37)
        ])
        
//        let closeButton = UIButton.customBack()
//        headerBar.addLeftButton(button: closeButton)
        //closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        
    }

    private func createContent() {
        let bgrdView = UIView()
        self.view.insertSubview(bgrdView, at: 0)
        bgrdView.backgroundColor = .themeBackgroundMain
        bgrdView.clipsToBounds = true
        bgrdView.layer.cornerRadius = 32
        bgrdView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bgrdView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bgrdView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            bgrdView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            bgrdView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bgrdView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        profView = CatProfView(frame: .zero)
        self.view.addSubview(profView)
        profView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            profView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            profView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            profView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        specView = CatSpecView(presenter: presenter)
        self.view.addSubview(specView)
        specView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            specView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            specView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            specView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            specView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        let mainImage = UIImageView()
        self.view.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.contentMode = .center
        mainImage.image = UIImage(named: "prof_main")
        
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: self.headerBar.bottomAnchor, constant: 30),
            mainImage.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30),
            mainImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mainImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        ])
        
    }
    
    func show(items: [CatEntity]) {
        switch items.first!.type {
        case .profession:
            showProfessions(items: items)
        case .specialisation:
            showSpecialisations(items: items)
        }
    }
    
    private func showProfessions(items: [CatEntity]) {
        specView.isHidden = true
        profView.isHidden = false
        profView.show(items: items)
    }
    
    private func showSpecialisations(items: [CatEntity]) {
        profView.isHidden = true
        specView.isHidden = false
        specView.show(items: items)
    }
    
    private func entitySelected(_ entity: CatEntity) {
        presenter.selectEntity(entity: entity)
    }
}
