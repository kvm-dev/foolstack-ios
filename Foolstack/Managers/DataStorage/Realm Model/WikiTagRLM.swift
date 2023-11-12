//
//  WikiTagRLM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import RealmSwift

class WikiTagRLM: Object {
    @Persisted (primaryKey: true) var serverId: Int
    @Persisted var name = ""
    @Persisted var items: List<WikiItemRLM>
    
    convenience init(serverId: Int, name: String = "", items: [WikiItemRLM]) {
        self.init()
        self.serverId = serverId
        self.name = name
        self.items.append(objectsIn: items)
    }
}
