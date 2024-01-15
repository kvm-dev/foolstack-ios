//
//  CatFlowBuilder.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 28.12.2023.
//

import Foundation
import UIKit

@MainActor
final class CatFlowBuilder {
    //    class func build() -> UIViewController {
    //        let router = CatListRouterImp()
    //        let cacheService = DataCacheImp(
    //            network: MockNetworkClient(),
    //            storageConfig: LocalStorageConfig())
    //        let repo = CatListRepoImp(cacheService: cacheService)
    //        let interactor = CatListInteractor(repo: repo)
    //        let presenter = CatListPresenterImp(router: router, interactor: interactor)
    //        let view = CatListVC()
    ////        view.navigationController?.isNavigationBarHidden = true
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
        let vm = CatChoiceVM(cacheService: cacheService, userStorage: userStorage)
        
        let vc = CatListVC(viewModel: vm)
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        return nc
    }
}

