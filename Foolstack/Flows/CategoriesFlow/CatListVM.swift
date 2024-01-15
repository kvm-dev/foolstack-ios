//
//  CatListVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 02.01.2024.
//

import Foundation
import Combine

@MainActor
final class CatChoiceVM: CatChoiceVMP {
    var onShowProfessions: ((CatProfListVM) -> Void)?
    var onShowSpecializations: ((CatSpecListVM) -> Void)?
    var onShowTags: ((TagListVM) -> Void)?
    var onShowMainFlow: (() -> Void)?

    private let cacheService: DataCacheService
    private let userStorage: UserStorage
    private var collectionStack: [CatListVMP] = []
    
    private var rootCategories: [CatEntity] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(cacheService: DataCacheService, userStorage: UserStorage) {
        self.cacheService = cacheService
        self.userStorage = userStorage
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
        rootCategories = items
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
        showTags(items: items, selectedSubCategories: parentIds)
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
    
    func showTags(items: [TagEntity], selectedSubCategories: [ServerKey]) {
        let vm = TagListVM(items: items, cacheService: cacheService, userStorage: userStorage)
        vm.confirmPublisher
            .sink(receiveValue: { [weak self] tagsVM in
                self?.tagsSelected(selectedTags: tagsVM.selectedTags, selectedSubCategories: selectedSubCategories)
            })
            .store(in: &subscriptions)
        onShowTags?(vm)
    }
    
    private func tagsSelected(selectedTags: [ServerKey], selectedSubCategories: [ServerKey]) {
        userStorage.saveSelectedSubCategories(selectedSubCategories)
        userStorage.saveSelectedTags(selectedTags)
        onShowMainFlow?()
    }
}


protocol CatListVMP {
    
}
