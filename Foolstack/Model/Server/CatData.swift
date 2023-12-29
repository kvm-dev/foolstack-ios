//
//  CatData.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 27.12.2023.
//

import Foundation

struct CatData: Codable {
    let id: ServerKey
    let type: Int
    let name: String
    let image: String?
    let categories: [CatData]
    let tags: [TagData]
}

extension CatData: Hashable {
    static func == (lhs: CatData, rhs: CatData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
