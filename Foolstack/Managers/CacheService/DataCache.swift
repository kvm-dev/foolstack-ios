//
//  DataCache.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation

final class DataCacheImp : DataCacheService {
    let network: NetworkClient
    let storage: DataStorage
    
    init(network: NetworkClient, storageConfig: StorageConfig) {
        self.network = network
        self.storage = DataStorage(config: storageConfig)
    }
    
    func getWikis() async -> [WikiListEntity] {
        return []
    }
    
    
}
