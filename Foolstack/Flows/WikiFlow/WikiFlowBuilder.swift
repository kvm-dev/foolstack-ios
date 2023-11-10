//
//  WikiFlowBuilder.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation
import UIKit

@MainActor
final class WikiFlowBuilder {
    class func build() -> UIViewController {
        let router = WikiListRouterImp()
        let repo = WikiListRepoImp()
        let interactor = WikiListInteractor(repo: repo)
        let presenter = WikiListPresenterImp(router: router, interactor: interactor)
        let view = WikiListVC.controllerFromStoryboard(.wiki)
        
        view.presenter = presenter
        router.viewController = view
        interactor.output = presenter
        
        return view
    }
}
