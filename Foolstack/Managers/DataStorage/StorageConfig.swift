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
