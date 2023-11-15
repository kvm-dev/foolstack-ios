//
//  WikiListRepoImp.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation

final class WikiListRepoImp : WikiListRepo {
    let cacheService: DataCacheService
    
    init(cacheService: DataCacheService) {
        self.cacheService = cacheService
    }
    
    func fetchEntities(completion: @escaping ([WikiListEntity]?, Error?) -> Void) {
        
        let items = [
            WikiListEntity(serverId: 1, ask: "T1", shortAnswer: "A1", fullAnswerExists: true, fullAnswer: "Full A1", tags: []),
            WikiListEntity(serverId: 2, ask: "T2", shortAnswer: "A2", fullAnswerExists: false, fullAnswer: nil, tags: [])
        ]
        completion(items, nil)
    }
    
    func fetchTags(keys: [ServerKey]) async throws -> [TagEntity] {
        let tags = try await cacheService.getTags(for: keys)
        return tags
    }
}
