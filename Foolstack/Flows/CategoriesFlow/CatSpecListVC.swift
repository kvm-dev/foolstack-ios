//
//  CatSpecListVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 29.12.2023.
//

import Foundation
import UIKit

@MainActor
final class CatSpecListVC : UIViewController, CatListView {
    
    var presenter: CatListPresenter!
    
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
    
    func show(items: [CatEntity]) {
        
    }
    
}
