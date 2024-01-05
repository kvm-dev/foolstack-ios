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

        let vc = CatFlowBuilder.build()
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        self.add(nc)
        self.view.addSubview(nc.view)
        nc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nc.didMove(toParent: self)
    }

    
}

