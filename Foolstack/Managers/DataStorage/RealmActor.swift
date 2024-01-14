//
//  RealmActor.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import Foundation
import RealmSwift

typealias ServerKey = Int

actor RealmActor {
    private var _realm: Realm!
    let config: Realm.Configuration
    
    init(config: Realm.Configuration) {
        self.config = config
    }
    
    func getRealm() async throws -> Realm {
        if let realm = _realm {
            return realm
        }
        _realm = try await Realm(configuration: config, actor: self)
        return _realm
    }
    
    func createRealm() async throws -> Realm {
        try await Realm(configuration: config, actor: self)
    }
    
    //MARK: Wiki Item
    
    func createOrUpdateWikiItem(serverId: ServerKey, ask: String, shortAnswer: String, isFullAnswer: Bool, fullAnswer: String?) async throws -> WikiItemRLM {
        let item = WikiItemRLM()
        item.serverId = serverId
        item.ask = ask
        item.shortAnswer = shortAnswer
        item.fullAnswerExist = isFullAnswer
        if let fullAnswer = fullAnswer {
            item.fullAnswer = WikiAnswerRLM(content: fullAnswer)
        }
        
        let realm = try await getRealm()
        try await realm.asyncWrite {
            realm.add(item, update: .modified)
        }
        
        return item
    }
    
    func addWikiItems(_ data: [WikiData]) async throws -> [WikiListEntity] {
        let items = data.map (WikiItemRLM.init)
        
        let realm = try await getRealm()
        try await realm.asyncWrite {
            realm.add(items, update: .modified)
        }
        
        //        var taggedItems: [Int:[WikiItemRLM]] = [:]
        //        data.forEach { d in
        //            if let item = items.first(where: { i in i.serverId == d.id }) {
        //                d.tags.forEach { t in
        //                    taggedItems[t, default: []].append(item)
        //                }
        //            }
        //        }
        //
        //        for (key, value) in taggedItems {
        //            try await addItemsToTag(id: key, items: value)
        //        }
        //
        //        print(taggedItems)
        
        return convertWikiItemsToEntities(items)
    }
    
    func updateWikiFullAnswer(serverId: ServerKey, value: String?) async throws {
        let realm = try await getRealm()
        let item = realm.object(ofType: WikiItemRLM.self, forPrimaryKey: serverId)
        try await realm.asyncWrite {
            item?.fullAnswer = value != nil ? WikiAnswerRLM(content: value!) : nil
        }
    }
    
    private func getWikiItems(for tags: [ServerKey]) async throws -> [WikiItemRLM] {
        let realm = try await getRealm()
        let predicate = NSPredicate(format: "ANY tags IN %@", tags)
        let result = realm.objects(WikiItemRLM.self)//.filter(predicate)
            .where {
                $0.tags.containsAny(in: tags)
            }
        let res = Array(result)
        //        print(res)
        return res
    }
    
    func getWikiEntities(for tags: [ServerKey]) async throws -> [WikiListEntity] {
        let items = try await getWikiItems(for: tags)
        return convertWikiItemsToEntities(items)
    }
    
    func convertWikiItemsToEntities(_ items: [WikiItemRLM]) -> [WikiListEntity] {
        items.map { WikiListEntity(serverId: $0.serverId, ask: $0.ask, shortAnswer: $0.shortAnswer, fullAnswerExists: $0.fullAnswerExist, fullAnswer: $0.fullAnswer?.content, tags: Array($0.tags))}
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
        let realm = try await getRealm()
        let item = realm.object(ofType: WikiItemRLM.self, forPrimaryKey: objid)
        if let item = item {
            try await realm.asyncWrite {
                realm.delete(item)
            }
        }
    }
    
    //MARK: Wiki TAG
    
    func addTags(from data: [TagData]) async throws -> [TagEntity] {
        let items = data.map (WikiTagRLM.init)
        
        let realm = try await getRealm()
        try await realm.asyncWrite {
            realm.add(items, update: .modified)
        }
        
        return convertTagsToEntities(items)
    }
    
    func createTag(serverId: Int, name: String, items: [WikiItemRLM]) async throws -> WikiTagRLM {
        let item = WikiTagRLM(serverId: serverId, name: name, items: items)
        
        let realm = try await getRealm()
        try await realm.asyncWrite {
            realm.add(item, update: .modified)
        }
        
        return item
    }
    
    func addItemsToTag(id: ServerKey, items: [WikiItemRLM]) async throws {
        let realm = try await getRealm()
        if let tag = realm.object(ofType: WikiTagRLM.self, forPrimaryKey: id) {
            try realm.write {
                tag.items.append(objectsIn: items)
            }
        }
    }
    
    private func getTags(for ids: [ServerKey]) async throws -> any Sequence<WikiTagRLM> {
        let realm = try await getRealm()
        if ids.isEmpty {
            let result = realm.objects(WikiTagRLM.self)
            return result
        } else {
            let result = realm.objects(WikiTagRLM.self).where {
                $0.serverId.in(ids)
            }
            return result
        }
    }
    
    func getTagEntities(for ids: [ServerKey]) async throws -> [TagEntity] {
        let tags = try await getTags(for: ids)
        return convertTagsToEntities(tags)
    }
    
    func convertTagsToEntities(_ tags: any Sequence<WikiTagRLM>) -> [TagEntity] {
        let ents = tags.map { TagEntity(serverId: $0.serverId, name: $0.name)}
        return ents
    }
    
    
}

extension Realm: @unchecked Sendable {}
