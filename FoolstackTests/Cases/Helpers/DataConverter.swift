//
//  DataConverter.swift
//  FoolstackTests
//
//  Created by Evgeniy Zolkin on 14.11.2023.
//

@testable import Foolstack

func convertRealmItemsToServerData(_ items: [WikiListEntity]) -> [WikiData] {
    items.map { WikiData(id: $0.serverId, imageURL: nil, ask: $0.ask, shortAnswer: $0.shortAnswer, fullAnswerExists: $0.fullAnswerExists, fullAnswer: nil, tags: $0.tags)}
}

func convertRealmTagsToServerData(_ items: [TagEntity]) -> [TagData] {
    items.map { TagData(id: $0.serverId, name: $0.name)}
}
