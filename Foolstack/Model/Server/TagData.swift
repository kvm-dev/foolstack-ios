//
//  TagData.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 13.11.2023.
//

import Foundation

struct TagData: Codable {
    let id: ServerKey
    let name: String
}

extension TagData: Hashable {
    static func == (lhs: TagData, rhs: TagData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
