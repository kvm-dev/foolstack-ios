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
        self.database = RealmActor(config: realmConfig)
    }
    
    func addItems(_ data: [WikiData]) async -> [WikiListEntity] {
        do {
            let items = try await database.addWikiItems(data)
            return items
        } catch {
            print("Create wiki items failed:", error)
        }
        return []
    }
    
    func getWikiEntities(for tags: [ServerKey]) async -> [WikiListEntity] {
        do {
            let items = try await database.getWikiEntities(for: tags)
            return items
        } catch {
            print("Get wiki items failed:", error)
        }
        return []
    }
    
    //MARK: TAGS
    
    func addTags(_ data: [TagData]) async -> [TagEntity] {
        do {
            let items = try await database.addTags(from: data)
            return items
        } catch {
            print("Create wiki tags failed:", error)
        }
        return []
    }
    
    func getTagEntities(for ids: [ServerKey]) async -> [TagEntity] {
        do {
            let items = try await database.getTagEntities(for: ids)
            return items
        } catch {
            print("Get wiki tags failed:", error)
        }
        return []
    }

    //MARK: TICKETS
    
    func addTickets(_ data: [TicketData]) async -> [TicketEntity] {
        do {
            let items = try await database.addTickets(data)
            return items
        } catch {
            print("Create tickets failed:", error)
        }
        return []
    }
    
    func getTicketEntities(for ids: [ServerKey]) async -> [TicketEntity] {
        do {
            let items = try await database.getTicketEntities(for: ids)
            return items
        } catch {
            print("Get tickets failed:", error)
        }
        return []
    }

    //MARK: Categories
    
    func addCategories(_ data: [CatData]) async -> [CatEntity] {
        do {
            let items = try await database.addCategories(data)
            return items
        } catch {
            print("Create categories failed:", error)
        }
        return []
    }
    
    func getCategoryEntities() async -> [CatEntity] {
        do {
            let items = try await database.getCategoryEntities()
            return items
        } catch {
            printToConsole("Get categories failed:", error)
        }
        return []
    }

}
