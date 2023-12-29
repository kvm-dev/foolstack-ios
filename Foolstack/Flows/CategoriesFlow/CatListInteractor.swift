//
//  CatListInteractor.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 28.12.2023.
//

import Foundation

@MainActor
final class CatListInteractor : CatListInteractorInput {
    weak var output: CatListInteractorOutput?
    private let repo: CatListRepo
    
    private var loadedTags: [TagEntity] = []
    
    init(repo: CatListRepo) {
        self.repo = repo
    }
    
    func fetchEntities(parentId: ServerKey) {
        Task { [weak self, output] in
            guard let self = self else {return}
            do {
                let items = try await self.repo.fetchEntities(parentId: parentId)
                output?.fetchEntitiesSuccess(items: items)
            } catch {
                output?.fetchEntitiesFailure(error: error)
            }
        }
    }
    
}
