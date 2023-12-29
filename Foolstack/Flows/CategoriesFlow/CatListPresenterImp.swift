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
    
    func selectEntity(index: Int) {
        
    }
    
}


extension CatListPresenterImp : CatListInteractorOutput {
    func fetchEntitiesSuccess(items: [CatEntity]) {
        view?.show(items: items)
    }
    
    func fetchEntitiesFailure(error: Error) {
        
    }
    
}
