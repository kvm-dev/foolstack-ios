//
//  TicketData.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

import Foundation

struct TicketData: Codable {
    let id: ServerKey
    let name: String
    let questions: [TicketQuestionData]
    let tags: [ServerKey]
}

extension TicketData: Hashable {
    static func == (lhs: TicketData, rhs: TicketData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
