//
//  WikiListPresenterImp.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation

final class WikiListPresenterImp: WikiListPresenter {
    private weak var view: WikiListView?
    private let router: WikiListRouter
    private let interactor: WikiListInteractorInput
    
    init(router: WikiListRouter, interactor: WikiListInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad(view: WikiListView) {
        self.view = view
        
        interactor.fetchEntities()
    }
    
    
}


extension WikiListPresenterImp : WikiListInteractorOutput {
    func fetchEntitiesSuccess(items: [WikiListEntity]) {
        view?.show(items: items)
    }
    
    func fetchEntitiesFailure(error: Error) {
        
    }
    
    
}
