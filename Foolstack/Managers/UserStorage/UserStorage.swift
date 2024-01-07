//
//  UserStorage.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 06.01.2024.
//

import Foundation

fileprivate let saveKey_SelectedTags = "SelectedTags"

final class UserStorage {
    private var config: UserStorageConfig
    
    init(config: UserStorageConfig) {
        self.config = config
    }
    
    func getSelectedTags() -> [ServerKey] {
        config.getUserDefaults().array(forKey: saveKey_SelectedTags) as? [Int] ?? []
    }
}

