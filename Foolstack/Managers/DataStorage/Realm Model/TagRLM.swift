//
//  WikiTagRLM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import RealmSwift

class TagRLM: Object {
    @Persisted (primaryKey: true) var serverId: ServerKey
    @Persisted var name: String
    @Persisted var parent: ServerKey
    
    convenience init(serverId: ServerKey, name: String, parent: ServerKey) {
        self.init()
        self.serverId = serverId
        self.name = name
        self.parent = parent
    }
    
    convenience init(_ data: TagData) {
        self.init()
        self.serverId = data.id
        self.name = data.name
        self.parent = data.parent
    }
}


extension TagEntity {
    init(rlm: TagRLM) {
        self.serverId = rlm.serverId
        self.name = rlm.name
        self.parent = rlm.parent
    }
}
