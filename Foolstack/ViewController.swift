//
//  ViewController.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 01.11.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dir = urls[0]
        print(dir)

        let cacheService = DataCacheImp(
            network: MockNetworkClient(),
            storageConfig: LocalStorageConfig())
        let userStorage = UserStorage(config: LocalUserStarageConfig())

        //let vc = WikiFlowBuilder.build()
        //let vc = MainTabVC()
        var vc: UIViewController?
        if userStorage.getUserToken() == nil {
            vc = StartVC()
        } else if userStorage.getSelectedSubCategories().isEmpty ||
            userStorage.getSelectedTags().isEmpty {
            vc = CatFlowBuilder.build()
        } else {
            vc = MainTabVC()
        }
        self.navigationController?.setViewControllers([vc!], animated: false)
  
//        nc.isNavigationBarHidden = true
//        self.add(vc)
//        self.view.addSubview(vc.view)
//        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        vc.didMove(toParent: self)
    }    
}

