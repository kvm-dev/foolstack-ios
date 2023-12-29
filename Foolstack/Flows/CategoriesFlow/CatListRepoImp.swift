//
//  CatListRepoImp.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 28.12.2023.
//

import Foundation

final class CatListRepoImp : CatListRepo {
    let cacheService: DataCacheService
    
    init(cacheService: DataCacheService) {
        self.cacheService = cacheService
    }
    
    func fetchEntities(parentId: ServerKey) async throws -> [CatEntity] {
        let items = try await cacheService.getCategories(parentId: parentId)
        return items
    }
    
}
