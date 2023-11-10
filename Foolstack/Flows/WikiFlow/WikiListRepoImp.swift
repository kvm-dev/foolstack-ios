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
            WikiListEntity(title: "T1", shortAnswer: "A1"),
            WikiListEntity(title: "T2", shortAnswer: "A2")
        ]
        completion(items, nil)
    }
}
