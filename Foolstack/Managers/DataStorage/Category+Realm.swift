//
//  Category+Realm.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 14.01.2024.
//

import RealmSwift

extension RealmActor {
    func addCategories(_ data: [CatData]) async throws -> [CatEntity] {
        let items = data.map (CatRLM.init)
        
        let realm = try await getRealm()
        try await realm.asyncWrite {
            realm.add(items, update: .modified)
        }
        
        return items.map(CatEntity.init)
    }
    
    private func getCategoryItems() async throws -> [CatRLM] {
        let realm = try await getRealm()
        let result = realm.objects(CatRLM.self)
        let res = Array(result)
        return res
    }
    
    func getCategoryEntities() async throws -> [CatEntity] {
        let items = try await getCategoryItems()
        return items.map(CatEntity.init)
    }
}
