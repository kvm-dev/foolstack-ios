//
//  UserStorage.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 06.01.2024.
//

import Foundation

fileprivate let saveKey_SelectedTags = "SelectedTags"
fileprivate let saveKey_SelectedSubCategories = "SelectedCats"
fileprivate let saveKey_TicketsResults = "TicketsResults"
fileprivate let saveKey_UserToken = "UserToken"

final class UserStorage {
    private var config: UserStorageConfig
    
    init(config: UserStorageConfig) {
        self.config = config
    }
    
    func saveUserToken(_ token: String?) {
        config.getUserDefaults().set(token, forKey: saveKey_UserToken)
    }
    
    func getUserToken() -> String? {
        config.getUserDefaults().string(forKey: saveKey_UserToken)
    }
    
    func saveSelectedSubCategories(_ cats: [ServerKey]) {
        config.getUserDefaults().set(cats, forKey: saveKey_SelectedSubCategories)
    }
    
    func getSelectedSubCategories() -> [ServerKey] {
        config.getUserDefaults().array(forKey: saveKey_SelectedSubCategories) as? [Int] ?? []
    }
    
    func saveSelectedTags(_ tags: [ServerKey]) {
        config.getUserDefaults().set(tags, forKey: saveKey_SelectedTags)
    }
    
    func getSelectedTags() -> [ServerKey] {
        config.getUserDefaults().array(forKey: saveKey_SelectedTags) as? [Int] ?? []
    }
    
    func saveTicketResult(ticketId: Int, completionPercent: Int) {
        var results: [String : Int] = config.getUserDefaults().dictionary(forKey: saveKey_TicketsResults) as? [String : Int] ?? [:]
        results["\(ticketId)"] = completionPercent
        config.getUserDefaults().set(results, forKey: saveKey_TicketsResults)
    }
    
    func getTicketsResults() -> [Int : Int] {
        let results = config.getUserDefaults().dictionary(forKey: saveKey_TicketsResults) as? [String : Int] ?? [:]
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
        let results: [Int : Int] = config.getUserDefaults().dictionary(forKey: saveKey_TicketsResults) as? [Int : Int] ?? [:]
        return results[ticketId] ?? 0
    }
}

