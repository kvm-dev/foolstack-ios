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
        
        guard let controller = customizableViewControllers?.first as? UINavigationController else {
            return
        }

        showWikiFlow()
    }
    
    private func showWikiFlow() {
        self.selectedIndex = 0
        guard let controller = viewControllers?[0] as? UINavigationController else { return }

        let vc = WikiFlowBuilder.build()
        controller.setViewControllers([vc], animated: false)
    }
}
