//
//  WikiEntity.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation

struct WikiListEntity {
    let serverId: Int
    let ask: String
    let shortAnswer: String
    let fullAnswerExists: Bool
    let fullAnswer: String?
}
