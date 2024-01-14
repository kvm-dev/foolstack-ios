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
    var backButton: UIButton!
    var mainImage: UIImageView!
    var bottomNC: UINavigationController!
    private let transition = CustomNavigationAnimator(operation: .push)
    private var transitionImages: [UIView] = []

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
        viewModel.onShowTags = { [unowned self] vm in
            self.showTags(viewModel: vm)
        }

        viewModel.load()
    }
    
    private func createHeader() {
        headerBar = HeaderBar(withSlider: false)
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerBar)
        headerBar.color = .clear
        headerBar.titleLabel.font = CustomFonts.defaultMedium(size: 22)
        headerBar.titleLabel.textColor = .themeTextViewTitle
        //headerBar.headerView.backgroundColor = .themeBackgroundMain
        //headerBar.pinEdges(to: view, leading: 8, trailing: -8, top: 0)
        headerBar.titleLabel.text = String(localized: "Choice profession")
        
        NSLayoutConstraint.activate([
            headerBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            headerBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            headerBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 37)
        ])
        
        backButton = UIButton.customBack()
        backButton.tintColor = .themeTextViewTitle
        headerBar.addLeftButton(button: backButton)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        backButton.isHidden = true
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
        self.transitionImages.append(mainImage)
        
        createBottomView()
    }
    
    private func createBottomView() {
        bottomNC = UINavigationController(rootViewController: UIViewController())
        self.add(bottomNC)
        self.view.addSubview(bottomNC.view)
        bottomNC.view.translatesAutoresizingMaskIntoConstraints = false
        bottomNC.didMove(toParent: self)
        bottomNC.setNavigationBarHidden(true, animated: false)
        bottomNC.delegate = self

        NSLayoutConstraint.activate([
            bottomNC.view.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            bottomNC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomNC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomNC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    private func showListView(_ listView: UIViewController) {
        bottomNC.pushViewController(listView, animated: true)
        updateNavigationBar()
    }
    
    private func showProfessions(viewModel: CatProfListVM) {
        animateTransitionImages()

        let vc = CatProfView(viewModel: viewModel)
        vc.title = String(localized: "Choice profession", comment: "")
        showListView(vc)
    }
    
    private func showSpecialisations(viewModel: CatSpecListVM) {
        animateTransitionImages()

        let vc = CatSpecView(viewModel: viewModel)
        vc.title = String(localized: "Choice specialization", comment: "")
        showListView(vc)
    }
    
    private func showTags(viewModel: TagListVM) {
        let vc = TagListVC(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func animateTransitionImages() {
        let outImageView = transitionImages.last
        if let imageGetter = bottomNC.viewControllers.last as? TransitionImageGetter,
           let img = imageGetter.getNextTransitionImageView() {
           let profImageView = UIImageView(image: img.image) //} img.snapshotView(afterScreenUpdates: false) {
            profImageView.contentMode = .scaleAspectFit
            // img.superview?.addSubview(v)
            // v.frame = cell.imageView.frame

            let r1 = self.view.convert(img.frame, from: img.superview!)
            //let r = self.view.convert(profImageView.frame, from: profImageView.superview!)
            //print("Converted frame \(r)")
            //NSLayoutConstraint.deactivate(profImageView.constraints)
            //profImageView.removeFromSuperview()
            self.view.addSubview(profImageView)
            profImageView.translatesAutoresizingMaskIntoConstraints = false
            profImageView.frame = r1
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
            self.transitionImages.append(profImageView)
        }

        if transitionImages.count <= 1 {
            return
        }
//        specView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        UIView.animate(withDuration: 0.5) {
//            self.specView.isHidden = false
//            self.profView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
//            self.specView.transform = CGAffineTransform.identity
            outImageView?.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
        } completion: { fin in
//            self.profView.isHidden = true
            
        }
    }
    
    private func updateNavigationBar() {
        backButton.isHidden = bottomNC.viewControllers.count <= 2
        headerBar.titleLabel.text = bottomNC.viewControllers.last?.title
    }
    
    @objc private func backPressed() {
        bottomNC.popViewController(animated: true)
        updateNavigationBar()

        let currentImageView = transitionImages.last
        if currentImageView != nil {
            transitionImages.removeLast()
        }
        let prevImageView = transitionImages.last
        UIView.animate(withDuration: 0.5) {
//            self.specView.isHidden = false
//            self.profView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
//            self.specView.transform = CGAffineTransform.identity
            prevImageView?.transform = CGAffineTransform.identity//(translationX: -self.view.bounds.width, y: 0)
            currentImageView?.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        } completion: { fin in
//            self.profView.isHidden = true
            currentImageView?.removeFromSuperview()
            
        }
    }
}

extension CatListVC: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.operation = operation
    return transition
  }
}


@MainActor
protocol TransitionImageGetter {
    func getNextTransitionImageView() -> UIImageView?
    func setPreviousImageView(imageView: UIImageView)
    func getPreviousTransitionImageView() -> UIImageView?
}

@MainActor
protocol ViewTitleGetter  {
    //func get
}
