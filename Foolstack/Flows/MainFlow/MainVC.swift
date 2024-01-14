//
//  MainVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation
import UIKit

final class MainVC : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let controller = customizableViewControllers?.first as? UINavigationController else {
//            return
//        }
//
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let dir = urls[0]
//        print(dir)
//
//        showWikiFlow()
    }
    
    private func showWikiFlow() {
        self.selectedIndex = 0
        guard let controller = viewControllers?[0] as? UINavigationController else { return }

        controller.isNavigationBarHidden = true
        //let vc = WikiFlowBuilder.build()
        let vc = CatFlowBuilder.build()
        controller.setViewControllers([vc], animated: false)
    }
}
