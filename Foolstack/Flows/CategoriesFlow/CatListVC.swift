//
//  CatListVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 28.12.2023.
//

import Foundation
import UIKit

@MainActor
final class CatListVC : UIViewController {
    
    var viewModel: CatChoiceVM!
    
    var headerBar: HeaderBar!
    var mainImage: UIImageView!
    var profView: CatProfView!
    var specView: CatSpecView!
    
    init(viewModel: CatChoiceVM) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createHeader()
        createContent()
        
        viewModel.onShowProfessions = { [unowned self] vm in
            self.showProfessions(viewModel: vm)
        }
        viewModel.onShowSpecializations = { [unowned self] vm in
            self.showSpecialisations(viewModel: vm)
        }

        viewModel.getCategories(parentIds: [])
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

        profView = CatProfView()
        self.view.addSubview(profView)
        profView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            profView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            profView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            profView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        specView = CatSpecView()
        self.view.addSubview(specView)
        specView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            specView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            specView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            specView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            specView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        mainImage = UIImageView()
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
    
    private func showProfessions(viewModel: CatProfListVM) {
        specView.isHidden = true
        profView.isHidden = false
        profView.show(viewModel: viewModel)
    }
    
    private func showSpecialisations(viewModel: CatSpecListVM) {
        if let profImageView = profView.getCurrentCellImage() {
            let r = self.view.convert(profImageView.frame, from: profImageView.superview!)
            print("Converted frame \(r)")
            NSLayoutConstraint.deactivate(profImageView.constraints)
            profImageView.removeFromSuperview()
            self.view.addSubview(profImageView)
            //profImageView.translatesAutoresizingMaskIntoConstraints = true
            profImageView.frame = r
            //profImageView.center.y += 100
            NSLayoutConstraint.activate([
                profImageView.topAnchor.constraint(equalTo: self.headerBar.bottomAnchor, constant: 30),
                profImageView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30),
                profImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
                profImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            ])
            UIView.animate(withDuration: 0.5) {
                profImageView.superview!.layoutIfNeeded()
            }
        }

        //UIView.animate(withDuration: 3, delay: 0, options: [.bo], animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        //UIView.transition(from: profView, to: specView, duration: 3, options: [.showHideTransitionViews, .transitionCurlUp])
//        profView.isHidden = true
//        specView.isHidden = false
        
        specView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        UIView.animate(withDuration: 0.5) {
            self.specView.isHidden = false
            self.profView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
            self.specView.transform = CGAffineTransform.identity
            self.mainImage.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
        } completion: { fin in
            self.profView.isHidden = true
        }

        
        specView.show(viewModel: viewModel)
        
    }
    
}
