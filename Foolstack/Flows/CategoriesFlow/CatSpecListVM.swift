//
//  CatSpecListVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 02.01.2024.
//

import Foundation

final class CatSpecListVM: CatListVMP {
    var onConfirm: ([ServerKey]) -> Void
    
    let entities: [CatEntity]

    init(entities: [CatEntity], onConfirm: @escaping ([ServerKey]) -> Void) {
        self.onConfirm = onConfirm
        self.entities = entities
    }
    
    private var selectedEntities = Set<ServerKey>()

    /// Add or remove entity to selected set
    /// - Parameter entity:
    /// - Returns: is entity selected
    func select(entity: CatEntity) -> Bool {
        if let index = selectedEntities.firstIndex(of: entity.serverId) {
            selectedEntities.remove(at: index)
            return false
        } else {
            selectedEntities.insert(entity.serverId)
            return true
        }
    }
    
    func confirm() {
        onConfirm(Array(selectedEntities))
    }
    
    var isConfirmEnabled: Bool {
        !selectedEntities.isEmpty
    }
}
