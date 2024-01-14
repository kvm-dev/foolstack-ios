//
//  CatRLM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 14.01.2024.
//

import RealmSwift

class CatRLM: Object {
    @Persisted (primaryKey: true) var serverId: Int
    @Persisted var name: String
    @Persisted var type: Int
    @Persisted var parent: Int
    @Persisted var priority: Int
    @Persisted var image: String?
    @Persisted var children: List<CatRLM>

    convenience init(_ data: CatData) {
        self.init()
        self.serverId = data.professionId
        self.name = data.professionName
        self.type = data.type
        self.parent = data.parent
        self.priority = data.priority
        self.image = data.icon
        self.children.append(objectsIn: data.subProfessions.map(CatRLM.init))
    }
}


extension CatEntity {
    init(rlm: CatRLM) {
        self.serverId = rlm.serverId
        self.name = rlm.name
        self.type = CategoryType(rawValue: rlm.type)!
        self.parent = rlm.parent
        self.priority = rlm.priority
        self.image = rlm.image
        self.categories = rlm.children.map(CatEntity.init)
    }
}
