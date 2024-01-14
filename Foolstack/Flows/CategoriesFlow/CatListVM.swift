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
    
    //private var categories: [CatEntity] = []
    
    init(cacheService: DataCacheService) {
        self.cacheService = cacheService

    }
    
    func load() {
        getCategories()
    }

    func getCategories() {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                let items = try await self.cacheService.getCategories()
                self.fetchCategoriesSuccess(items: items)
            } catch {
                self.fetchEntitiesFailure(error: error)
            }
        }
    }
    
    func fetchCategoriesSuccess(items: [CatEntity]) {
        showCategories(items: items)
    }
    
    func fetchEntitiesFailure(error: Error) {
        print("Fetch categories failure: \(error)")
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
        case .superProfession, .profession:
            showProfessions(items: items)
        case .specialisation:
            showSpecializations(items: items)
        }
    }
    
    func showProfessions(items: [CatEntity]) {
        let vm = CatProfListVM(entities: items) { [weak self] ent in
            self?.categoryChoiced(ent)
        }
        
        collectionStack.append(vm)
        onShowProfessions?(vm)
    }
    
    private func categoryChoiced(_ entity: CatEntity) {
        if !entity.categories.isEmpty {
            showCategories(items: entity.categories)
        } else {
            getTags(parentIds: [entity.serverId])
        }
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
