//
//  TestingFlowBuilder.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 09.01.2024.
//

import UIKit

@MainActor
final class TestingFlowBuilder {
    class func build() -> UIViewController {
        let cacheService = DataCacheImp(
            network: MockNetworkClient(),
            storageConfig: LocalStorageConfig())
        let userStorage = UserStorage(config: LocalUserStarageConfig())
        let vm = TestingVM(cacheService: cacheService, userStorage: userStorage)
        
        let vc = TestingVC(viewModel: vm)
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        return nc
    }

}
