//
//  StorageConfig.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import Foundation
import RealmSwift

protocol StorageConfig {
    func getRealmConfig() -> Realm.Configuration
}


final class LocalStorageConfig : Sendable, StorageConfig {
    func getRealmConfig() -> Realm.Configuration {
        let config = Realm.Configuration.defaultConfiguration
        return config
    }
}


final class MemoryStorageConfig : Sendable, StorageConfig {
    func getRealmConfig() -> Realm.Configuration {
        let ident = "TestDB"
        let config = Realm.Configuration(inMemoryIdentifier: ident)
//        var config = Realm.Configuration.defaultConfiguration
//        config.fileURL!.deleteLastPathComponent()
//        config.fileURL!.appendPathComponent(ident)
//        config.fileURL!.appendPathExtension("realm")
        return config
    }
}
