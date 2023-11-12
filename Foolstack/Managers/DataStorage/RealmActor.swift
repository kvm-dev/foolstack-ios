//
//  RealmActor.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import Foundation
import RealmSwift

actor RealmActor {
    var realm: Realm!
    
    init(config: Realm.Configuration) async throws {
        self.realm = try await Realm(configuration: config, actor: self)
    }
    
    //MARK: Wiki Item
    func createOrUpdateWikiItem(serverId: Int, ask: String, shortAnswer: String, isFullAnswer: Bool, fullAnswer: String?) async throws -> WikiItemRLM {
        let item = WikiItemRLM()
        item.serverId = serverId
        item.ask = ask
        item.shortAnswer = shortAnswer
        item.fullAnswerExist = isFullAnswer
        if let fullAnswer = fullAnswer {
            item.fullAnswer = WikiAnswerRLM(content: fullAnswer)
        }
        
        try await realm.asyncWrite {
            realm.add(item, update: .modified)
        }
        
        return item
    }
    
    func createWikiItems(_ data: [WikiData]) async throws -> [WikiItemRLM] {
        let items = data.map (WikiItemRLM.init)
        
        try await realm.asyncWrite {
            realm.add(items)
        }
        
        return items
    }
    
    func getWikiItems() -> [WikiItemRLM] {
        let result = self.realm.objects(WikiItemRLM.self)
        return Array(result)
    }
    
    func getWikiEntities() -> [WikiListEntity] {
        convertWikiItemsToEntities(getWikiItems())
    }
    
    func convertWikiItemsToEntities(_ items: [WikiItemRLM]) -> [WikiListEntity] {
        items.map { WikiListEntity(serverId: $0.serverId, ask: $0.ask, shortAnswer: $0.shortAnswer, fullAnswerExists: $0.fullAnswerExist, fullAnswer: $0.fullAnswer?.content)}
    }

    
//    func updateWikiItem(ask: String, shortAnswer: String, isFullAnswer: Bool, fullAnswer: String?) async throws -> WikiItemRLM {
//        let item = WikiItemRLM()
//        item.ask = ask
//        item.shortAnswer = shortAnswer
//        item.fullAnswerExist = isFullAnswer
//        if let fullAnswer = fullAnswer {
//            item.fullAnswer = WikiAnswerRLM(content: fullAnswer)
//        }
//        
//        try await realm.asyncWrite {
//            realm.add(item, update: .modified)
//        }
//        
//        return item
//    }

    func deleteWikiItem(id: String) async throws {
        let objid = try ObjectId(string: id)
        let item = realm.object(ofType: WikiItemRLM.self, forPrimaryKey: objid)
        if let item = item {
            try await realm.asyncWrite {
                realm.delete(item)
            }
        }
    }
    
    //MARK: Wiki TAG
    
    func createTag(serverId: Int, name: String, items: [WikiItemRLM]) async throws -> WikiTagRLM {
        let item = WikiTagRLM(serverId: serverId, name: name, items: items)
        
        try await realm.asyncWrite {
            realm.add(item)
        }
        
        return item
    }
}


extension Realm: @unchecked Sendable {}
