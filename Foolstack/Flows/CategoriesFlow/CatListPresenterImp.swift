//
//  CatListPresenterImp.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 27.12.2023.
//

import Foundation

@MainActor
final class CatListPresenterImp: CatListPresenter {
    private weak var view: CatListView?
    private let router: CatListRouter
    private let interactor: CatListInteractorInput
    
    init(router: CatListRouter, interactor: CatListInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad(view: CatListView) {
        self.view = view
        
        //interactor.fetchEntities()
        interactor.fetchEntities(parentId: 0)
    }
    
    func selectEntity(entity: CatEntity) -> Bool {
        //router.openCatList(tags: <#T##[CatEntity]#>)
        switch entity.type {
        case .profession:
            interactor.fetchEntities(parentId: entity.serverId)
            return true
        case .specialisation:
            return interactor.selectEntity(entity: entity)
        }
    }
    
}


extension CatListPresenterImp : CatListInteractorOutput {
    func fetchEntitiesSuccess(items: [CatEntity]) {
        if !items.isEmpty {
            view?.show(items: items)
        } else {
            // fetch tags
        }
    }
    
    func fetchEntitiesFailure(error: Error) {
        
    }
    
}
