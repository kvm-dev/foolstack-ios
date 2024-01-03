//
//  CatProfListVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 02.01.2024.
//

import Foundation

final class CatProfListVM: CatListVMP {
    let onConfirm: (CatEntity) -> Void
    
    var entities: [CatEntity]
    
    init(entities: [CatEntity], onConfirm: @escaping (CatEntity) -> Void) {
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
