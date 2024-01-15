//
//  UserStorage.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 06.01.2024.
//

import Foundation

fileprivate let key_SelectedTags = "SelectedTags"
fileprivate let key_TicketsResults = "TicketsResults"

final class UserStorage {
    private var config: UserStorageConfig
    
    init(config: UserStorageConfig) {
        self.config = config
    }
    
    func getSelectedTags() -> [ServerKey] {
        config.getUserDefaults().array(forKey: key_SelectedTags) as? [Int] ?? []
    }
    
    func saveSelectedTags(_ tags: [ServerKey]) {
        config.getUserDefaults().set(tags, forKey: key_SelectedTags)
    }
    
    func saveTicketResult(ticketId: Int, completionPercent: Int) {
        var results: [String : Int] = config.getUserDefaults().dictionary(forKey: key_TicketsResults) as? [String : Int] ?? [:]
        results["\(ticketId)"] = completionPercent
        config.getUserDefaults().set(results, forKey: key_TicketsResults)
    }
    
    func getTicketsResults() -> [Int : Int] {
        let results = config.getUserDefaults().dictionary(forKey: key_TicketsResults) as? [String : Int] ?? [:]
        return results.reduce(into: [Int : Int](), {
            if let key = Int($1.key) {
                $0[key] = $1.value
            }
        })
//        results.reduce([String : Int]) { partialResult, (key, value) in
//            partialResult
//        }
    }

    func getTicketResult(ticketId: Int) -> Int {
        let results: [Int : Int] = config.getUserDefaults().dictionary(forKey: key_TicketsResults) as? [Int : Int] ?? [:]
        return results[ticketId] ?? 0
    }
}

