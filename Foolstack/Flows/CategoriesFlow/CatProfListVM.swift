//
//  CatProfListVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 02.01.2024.
//

import Foundation

final class CatProfListVM: CatListVMP {
    let onConfirm: (CatEntity) -> Void
    
    private(set) var parentEntity: CatEntity?
    private(set) var entities: [CatEntity]
    
    init(/*parentEntity: CatEntity?,*/ entities: [CatEntity], onConfirm: @escaping (CatEntity) -> Void) {
        //self.parentEntity = parentEntity
        self.entities = entities
        self.onConfirm = onConfirm
    }
    
    func confirm(index: Int) {
        onConfirm(entities[index])
    }
    
    func clear() {
        entities = []
    }
}
