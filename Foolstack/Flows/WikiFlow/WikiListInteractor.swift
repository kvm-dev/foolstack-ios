//
//  WikiListInteractor.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

final class WikiListInteractor : WikiListInteractorInput {
    
    weak var output: WikiListInteractorOutput?
    private let repo: WikiListRepo
    
    init(repo: WikiListRepo) {
        self.repo = repo
    }
    
    func fetchEntities() {
        repo.fetchEntities { [weak output] data, error in
            if let error = error {
                output?.fetchEntitiesFailure(error: error)
            }
            else if let data = data {
                output?.fetchEntitiesSuccess(items: data)
            } 
        }
    }

}
