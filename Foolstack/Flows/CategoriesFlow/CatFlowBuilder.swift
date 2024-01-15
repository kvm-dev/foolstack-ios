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
        let cacheService = DataCacheImp(
            network: MockNetworkClient(),
            storageConfig: LocalStorageConfig())
        let userStorage = UserStorage(config: LocalUserStarageConfig())
        let vm = CatChoiceVM(cacheService: cacheService, userStorage: userStorage)
        
        let vc = CatListVC(viewModel: vm)
        return vc
    }
}

