//
//  CatEntity.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 27.12.2023.
//

import Foundation

enum CategoryType: Int {
    case profession = 1
    case specialisation = 2
}


struct CatEntity {
    let serverId: Int
    let type: CategoryType
    let name: String
    let image: String?
    //let categories: [CatEntity]
    let tags: [TagEntity]
    
    init(data: CatData) {
        self.serverId = data.id
        self.type = CategoryType(rawValue: data.type) ?? .profession
        self.name = data.name
        self.image = data.image
        //self.categories = data.categories.map(CatEntity.init)
        self.tags = data.tags.map(TagEntity.init)
    }
}
