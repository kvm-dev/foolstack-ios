//
//  TagEntity.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 13.11.2023.
//

struct TagEntity {
    let serverId: ServerKey
    let name: String
    let parent: ServerKey
    
    //var selected: Bool
    
    init(data: TagData) {
        self.serverId = data.id
        self.name = data.name
        self.parent = data.id
    }
    
    init(serverId: ServerKey, name: String, parent: ServerKey) {
        self.serverId = serverId
        self.name = name
        self.parent = parent
    }
}
