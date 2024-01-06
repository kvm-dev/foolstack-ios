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
    
    func getCategories(parentIds: [ServerKey]) async throws -> [CatEntity] {

        let items = [
            CatData(id: 1, type: 1, name: "Cat 1", image: "prof_1.svg", categories: [], tags: []),
            CatData(id: 2, type: 1, name: "Cat 2", image: "prof_2.svg", categories: [
                CatData(id: 21, type: 2, name: "SubCat 21", image: nil, categories: [], tags: [
                    TagData(id: 211, name: "Tag 211")
                ])], tags: []),
        ]
        if !parentIds.isEmpty {
            return [
                CatData(id: 11, type: 2, name: "SubCat 11 kjlf sdkfjsdjf eiowjf sdfu8f ewf23 38 wfe09f83209f fe9f80293f 98309", image: "spec_droid.svg", categories: [], tags: [
                    TagData(id: 111, name: "Tag 111")
                ]),
                CatData(id: 12, type: 2, name: "SubCat 12", image: "spec_apple.svg", categories: [], tags: [
                    TagData(id: 112, name: "Tag 112")
                ])
            ].map(CatEntity.init)
        }
        return items.map(CatEntity.init)
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
