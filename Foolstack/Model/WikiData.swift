//
//  WikiData.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.11.2023.
//

import Foundation

struct WikiData: Codable, Equatable {
    
    // MARK: - Identifier Properties
    let id: Int
    
    // MARK: - Instance Properties
    let imageURL: URL?
    let ask: String
    let shortAnswer: String
    let fullAnswerExists: Bool
    let fullAnswer: String?
}
