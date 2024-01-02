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
    
    private var selectedEntities = Set<ServerKey>()
    
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
    
    /// Add or remove entity to selected set
    /// - Parameter entity:
    /// - Returns: is entity selected
    func selectEntity(entity: CatEntity) -> Bool {
        if let index = selectedEntities.firstIndex(of: entity.serverId) {
            selectedEntities.remove(at: index)
            return false
        } else {
            selectedEntities.insert(entity.serverId)
            return true
        }
    }
    
}
