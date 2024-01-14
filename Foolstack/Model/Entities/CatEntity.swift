//
//  CatEntity.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 27.12.2023.
//

import Foundation

enum CategoryType: Int {
    case superProfession = 0
    case profession = 1
    case specialisation = 2
}


struct CatEntity: Sendable {
    let serverId: ServerKey
    let type: CategoryType
    let name: String
    let parent: ServerKey
    let priority: Int
    let image: String?
    let categories: [CatEntity]
    //let tags: [TagEntity]
    
    init(data: CatData) {
        self.serverId = data.professionId
        self.type = CategoryType(rawValue: data.type)!
        self.name = data.professionName
        self.image = data.icon
        self.parent = data.parent
        self.priority = data.priority
        self.categories = data.subProfessions.map(CatEntity.init)
        //self.tags = data.tags.map(TagEntity.init)
    }

//    static func getImage(id: ServerKey) -> String? {
//        
//    }
}
