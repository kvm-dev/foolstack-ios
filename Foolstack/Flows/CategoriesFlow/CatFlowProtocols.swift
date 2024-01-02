//
//  CatFlowProtocols.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 27.12.2023.
//

import Foundation

@MainActor
protocol CatListPresenter: AnyObject {
    func viewDidLoad(view: CatListView)
    
    func selectEntity(entity: CatEntity) -> Bool
}

@MainActor
protocol CatListInteractorInput: AnyObject {
    func fetchEntities(parentId: ServerKey)
    func selectEntity(entity: CatEntity) -> Bool
}

@MainActor
protocol CatListInteractorOutput: AnyObject {
    func fetchEntitiesSuccess(items: [CatEntity])
    func fetchEntitiesFailure(error: Error)
    
}

@MainActor
protocol CatListRouter: AnyObject {
    func openCatList(parentId: ServerKey)
}

protocol CatListRepo: AnyObject {
    func fetchEntities(parentId: ServerKey) async throws -> [CatEntity]
}


@MainActor
protocol CatListView: AnyObject {
    func show(items: [CatEntity])
}

@MainActor
protocol SpecListView: AnyObject {
    func show(tags: [TagEntity])
}

