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
    class func build() -> UIViewController {
        let router = CatListRouterImp()
        let cacheService = DataCacheImp(
            network: MockNetworkClient(),
            storageConfig: LocalStorageConfig())
        let repo = CatListRepoImp(cacheService: cacheService)
        let interactor = CatListInteractor(repo: repo)
        let presenter = CatListPresenterImp(router: router, interactor: interactor)
        let view = CatListVC()
//        view.navigationController?.isNavigationBarHidden = true
        
        view.presenter = presenter
        router.viewController = view
        interactor.output = presenter
        
        return view
    }
}

