//
//  CatListVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 02.01.2024.
//

import Foundation

@MainActor
final class CatChoiceVM: CatChoiceVMP {
    var onShowProfessions: ((CatProfListVM) -> Void)?
    var onShowSpecializations: ((CatSpecListVM) -> Void)?
    var onShowTags: ((TagListVM) -> Void)?

    private let cacheService: DataCacheService
    private var collectionStack: [CatListVMP] = []
    
    init(cacheService: DataCacheService) {
        self.cacheService = cacheService

        
    }

    func getCategories(parentIds: [ServerKey]) {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                let items = try await self.cacheService.getCategories(parentIds: parentIds)
                self.fetchEntitiesSuccess(items: items, parentIds: parentIds)
            } catch {
                self.fetchEntitiesFailure(error: error)
            }
        }
    }
    
    func fetchEntitiesSuccess(items: [CatEntity], parentIds: [ServerKey]) {
        if items.isEmpty {
            getTags(parentIds: parentIds)
        } else {
            showCategories(items: items)
        }
    }
    
    func fetchEntitiesFailure(error: Error) {
        
    }
    
    func getTags(parentIds: [ServerKey]) {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                let items = try await self.cacheService.getTags(for: parentIds)
                self.fetchTagsSuccess(items: items, parentIds: parentIds)
            } catch {
                self.fetchTagsFailure(error: error)
            }
        }
    }
    
    func fetchTagsSuccess(items: [TagEntity], parentIds: [ServerKey]) {
        showTags(items: items)
    }
    
    func fetchTagsFailure(error: Error) {
        
    }
    
    func showCategories(items: [CatEntity]) {
        switch items.first!.type {
        case .profession:
            showProfetions(items: items)
        case .specialisation:
            showSpecializations(items: items)
        }
    }
    
    func showProfetions(items: [CatEntity]) {
        let vm = CatProfListVM(entities: items) { [weak self] ent in
            self?.getCategories(parentIds: [ent].map{$0.serverId})
        }
        
        collectionStack.append(vm)
        onShowProfessions?(vm)
    }
    
    func showSpecializations(items: [CatEntity]) {
        let vm = CatSpecListVM(entities: items, onConfirm: { [weak self] selectedIds in
            self?.getTags(parentIds: selectedIds)
        })
        
        collectionStack.append(vm)
        onShowSpecializations?(vm)
    }
    
    func showTags(items: [TagEntity]) {
        let vm = TagListVM(items: items, cacheService: cacheService)
        onShowTags?(vm)
    }
}


protocol CatListVMP {
    
}
