//
//  DataStorage.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import Foundation

final class DataStorage: @unchecked Sendable {
    static let shared = DataStorage(config: LocalStorageConfig())
    
    var database: RealmActor!
    
    init(config: StorageConfig) {
        let realmConfig = config.getRealmConfig()
        Task {
            do {
                self.database = try await RealmActor(config: realmConfig)
            } catch {
                print("Create DB error:", error)
            }
        }
    }
    
    func addItems(_ data: [WikiData]) async throws {
        let items = try await database.createWikiItems(data)
        
    }
    
    func getWikiEntities() async -> [WikiListEntity] {
        let items = await database.getWikiEntities()
        return items
    }
    
}
