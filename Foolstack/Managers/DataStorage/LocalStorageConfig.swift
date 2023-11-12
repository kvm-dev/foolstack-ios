//
//  LocalStorageConfig.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import Foundation
import RealmSwift

final class LocalStorageConfig : Sendable, StorageConfig {
    func getRealmConfig() -> Realm.Configuration {
        let ident = "TestDB"
        let config = Realm.Configuration(inMemoryIdentifier: ident)
        return config
    }
}
