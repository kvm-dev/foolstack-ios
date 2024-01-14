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
//    class func build() -> UIViewController {
//        let router = WikiListRouterImp()
//        let cacheService = DataCacheImp(
//            network: MockNetworkClient(),
//            storageConfig: LocalStorageConfig())
//        let repo = WikiListRepoImp(cacheService: cacheService)
//        let interactor = WikiListInteractor(repo: repo)
//        let presenter = WikiListPresenterImp(router: router, interactor: interactor)
//        let view = WikiListVC.controllerFromStoryboard(.wiki)
//        
//        view.presenter = presenter
//        router.viewController = view
//        interactor.output = presenter
//        
//        return view
//    }
    
    class func build() -> UIViewController {
        let cacheService = DataCacheImp(
            network: MockNetworkClient(),
            storageConfig: LocalStorageConfig())
        let userStorage = UserStorage(config: LocalUserStarageConfig())
        let vm = WikiListVM(cacheService: cacheService, userStorage: userStorage)
        
        let vc = WikiListVC(viewModel: vm)
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        return nc
    }

}
