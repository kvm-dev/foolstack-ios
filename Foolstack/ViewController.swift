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
        
        let vc = CatFlowBuilder.build()
        self.add(vc)
        self.view.addSubview(vc.view)
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: self)
    }

    
}

