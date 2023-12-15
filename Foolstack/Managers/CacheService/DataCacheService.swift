//
//  DataCacheService.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation

protocol DataCacheService {
    func getWikis(tags: [ServerKey]) async throws -> [WikiListEntity]
    func getTags(for keys: [ServerKey]) async throws -> [TagEntity]
}
