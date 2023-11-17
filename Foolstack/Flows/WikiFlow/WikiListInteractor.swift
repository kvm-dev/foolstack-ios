//
//  WikiListInteractor.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//
@MainActor
final class WikiListInteractor : WikiListInteractorInput {
    weak var output: WikiListInteractorOutput?
    private let repo: WikiListRepo
    
    private var loadedTags: [TagEntity] = []
    
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

    func fetchTags(keys: [ServerKey]) {
        Task { [weak self, output] in
            guard let self = self else {return}
            do {
                let items = try await self.repo.fetchTags(keys: keys)
                output?.fetchTagsSuccess(items: items)
            } catch {
                output?.fetchTagsFailure(error: error)
            }
        }
    }
    
}
