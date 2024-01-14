//
//  UserStorageConfig.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 06.01.2024.
//

import Foundation

protocol UserStorageConfig {
    func getUserDefaults() -> UserDefaults
}

final class LocalUserStarageConfig: UserStorageConfig {
    func getUserDefaults() -> UserDefaults {
        UserDefaults.standard
    }
}
