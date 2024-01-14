//
//  DataCacheService.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation

protocol DataCacheService {
    func getCategories(parentIds: [ServerKey]) async throws -> [CatEntity]
    func getWikis(tags: [ServerKey]) async throws -> [WikiListEntity]
    func getTags(for keys: [ServerKey]) async throws -> [TagEntity]
    func getTickets(for keys: [ServerKey]) async throws -> [TicketEntity]
}
