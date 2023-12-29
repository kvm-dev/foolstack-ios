//
//  DataCache.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation

final class DataCacheImp : DataCacheService {
    let network: NetworkService
    let storage: DataStorage
    
    init(network: NetworkService, storageConfig: StorageConfig) {
        self.network = network
        self.storage = DataStorage(config: storageConfig)
        
        DataCacheImp.createMockResources()
    }
    
    func getCategories(parentId: ServerKey) async throws -> [CatEntity] {
        return []
    }
    
    func getWikis(tags: [ServerKey]) async throws -> [WikiListEntity] {
        let storageItems = await storage.getWikiEntities(for: tags)
        if !storageItems.isEmpty {
            return storageItems
        }
        
        if let networkData = try await network.getWikis(tags: tags) {
            let storageEnts = await storage.addItems(networkData)
            return storageEnts
        }
        return []
    }
    
    func getTags(for keys: [ServerKey]) async throws -> [TagEntity] {
        let storageTags = await storage.getTagEntities(for: keys)
        if !storageTags.isEmpty {
            return storageTags
        }
        
        if let networkData = try await network.getTags() {
            let storageEnts = await storage.addTags(networkData)
            return storageEnts
        }
        return []
    }
}
