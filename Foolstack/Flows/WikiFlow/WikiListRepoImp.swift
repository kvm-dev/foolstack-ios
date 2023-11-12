//
//  WikiListRepoImp.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation

final class WikiListRepoImp : WikiListRepo {
    func fetchEntities(completion: @escaping ([WikiListEntity]?, Error?) -> Void) {
        let items = [
            WikiListEntity(serverId: 1, ask: "T1", shortAnswer: "A1", fullAnswerExists: true, fullAnswer: "Full A1"),
            WikiListEntity(serverId: 2, ask: "T2", shortAnswer: "A2", fullAnswerExists: false, fullAnswer: nil)
        ]
        completion(items, nil)
    }
}
