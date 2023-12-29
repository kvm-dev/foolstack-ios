//
//  TagEntity.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 13.11.2023.
//

struct TagEntity {
    let serverId: Int
    let name: String
    
    //var selected: Bool
    
    init(data: TagData) {
        self.serverId = data.id
        self.name = data.name
    }
    
    init(serverId: Int, name: String) {
        self.serverId = serverId
        self.name = name
    }
}
