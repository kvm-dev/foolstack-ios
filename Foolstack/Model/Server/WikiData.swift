//
//  WikiData.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation

struct WikiData: Codable {
    
    // MARK: - Identifier Properties
    let id: ServerKey
    
    // MARK: - Instance Properties
    let imageURL: URL?
    let ask: String
    let shortAnswer: String
    let fullAnswerExists: Bool
    let fullAnswer: String?
    let tags: [ServerKey]
}

extension WikiData: Hashable {
    static func == (lhs: WikiData, rhs: WikiData) -> Bool {
        return lhs.id == rhs.id
    }


    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
