//
//  CatData.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 27.12.2023.
//

import Foundation

struct CatData: Codable, Sendable {
    let professionId: ServerKey
    let professionName: String
    let type: Int
    let icon: String?
    let parent: ServerKey
    let priority: Int
    let subProfessions: [CatData]
}

extension CatData: Hashable {
    static func == (lhs: CatData, rhs: CatData) -> Bool {
        return lhs.professionId == rhs.professionId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(professionId)
    }
}


struct CatResponseData: Codable {
    let success: Bool
    let errorMsg: String
    let professions: [CatData]
}
