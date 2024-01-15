//
//  MainTabVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

import UIKit
import Combine

class MainTabVC: UITabBarController {
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.delegate = self
        
        let imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        
        let vc1 = WikiFlowBuilder.build()
        vc1.tabBarItem = UITabBarItem(title: nil, image: .symbolImage(.faq, pointSize: 18), selectedImage: .symbolImage(.faqActive, pointSize: 18))
        vc1.tabBarItem.imageInsets = imageInsets

        let vc2 = UIViewController()
        vc2.tabBarItem = UITabBarItem(title: nil, image: .symbolImage(.hr, pointSize: 10), selectedImage: .symbolImage(.hrActive, pointSize: 18))
        vc2.tabBarItem.imageInsets = imageInsets
        
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        vc2.view.addSubview(v)
        v.pinEdges(to: vc2.view.safeAreaLayoutGuide, padding: 0)

        let vc3 = TestingFlowBuilder.build()
        vc3.tabBarItem = UITabBarItem(title: nil, image: .symbolImage(.tests, pointSize: 18), selectedImage: .symbolImage(.tests, pointSize: 18))
        vc3.tabBarItem.imageInsets = imageInsets

        let tabarist = [vc1, vc2, vc3]
        self.viewControllers = tabarist
        self.selectedIndex = 0
        
        self.tabBar.backgroundColor = .themeBackgroundTop
        self.tabBar.layer.cornerRadius = 32
        //    self.tabBar.layer.shadowOffset = .zero
        //    self.tabBar.layer.shadowRadius = .shadowRadius(isRegular)
        //    self.tabBar.layer.shadowOpacity = .shadowOpacity
        //    self.tabBar.layer.shadowColor = UIColor.themeShadow1.cgColor
        
        self.tabBar.unselectedItemTintColor = .darkGray
        self.tabBar.tintColor = .orange
        
        //    self.tabBar.shadowImage = UIImage()
        //    self.tabBar.backgroundImage = UIImage()
        //    tabBarController?.tabBar.clipsToBounds = true
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        //    self.tabBar.layer.shadowColor = UIColor.themeShadow1.cgColor
    }
    
    
    
}


class CustomTabBar: UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sz = super.sizeThatFits(size)
        sz.height = 105
        return sz
    }
}
