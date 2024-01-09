//
//  TicketQuestionData.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

import Foundation

struct TicketQuestionData: Codable {
    let question: String
    let variants: [String]
    let answers: [Int]
}

