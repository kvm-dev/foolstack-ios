//
//  WikiListVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation
import UIKit

@MainActor
final class WikiListVC : UIViewController, WikiListView {
    
    var presenter: WikiListPresenter!
    
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
        
        presenter.viewDidLoad(view: self)
    }
    
    func show(items: [WikiListEntity]) {
        print(items)
    }
    
    func show(tags: [TagEntity]) {
        
    }
}
