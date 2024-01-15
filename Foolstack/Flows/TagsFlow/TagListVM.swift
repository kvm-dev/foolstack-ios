//
//  TagListVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 04.01.2024.
//

import Foundation
import Combine

@MainActor
final class TagListVM {
    //var onConfirm: ((TagListVM) -> Void)?
    var onItemsLoaded: (() -> Void)?
    @Published var isConfirmEnabled = false
    let confirmPublisher = PassthroughSubject<TagListVM, Never>()

    private(set) var items: [TagEntity]
    private let cacheService: DataCacheService
    private let userStorage: UserStorage
    
    var selectedTags: [Int] = [] {
        didSet {
            isConfirmEnabled = !selectedTags.isEmpty
        }
    }
    
    init(items: [TagEntity], cacheService: DataCacheService, userStorage: UserStorage) {
        self.cacheService = cacheService
        self.userStorage = userStorage
        self.items = items
        self.selectedTags = userStorage.getSelectedTags()
        
        if items.isEmpty {
            loadAllTags()
        }
    }
    
    private func loadAllTags() {
        let selectedCategories = userStorage.getSelectedSubCategories()
        Task { [weak self] in
            guard let self = self else {return}
            do {
                let items = try await self.cacheService.getTags(for: selectedCategories)
                self.fetchTagsSuccess(items: items)
            } catch {
                self.fetchTagsFailure(error: error)
            }
        }
    }
    
    private func fetchTagsSuccess(items: [TagEntity]) {
        self.items = items
        self.selectedTags = userStorage.getSelectedTags()
        onItemsLoaded?()
    }
    
    private func fetchTagsFailure(error: Error) {
        
    }
    
    func toggleItemAt(index: Int) -> Bool {
        let item = items[index]
        if let index = selectedTags.firstIndex(of: item.serverId) {
            selectedTags.remove(at: index)
            return false
        } else {
            selectedTags.append(item.serverId)
            return true
        }
    }
    
    func isItemSelectedAt(index: Int) -> Bool {
        let item = items[index]
        return selectedTags.firstIndex(of: item.serverId) != nil
    }
    
    func selectAll() {
        if selectedTags.count != items.count {
            selectedTags = items.map{$0.serverId}
        } else {
            selectedTags.removeAll()
        }
    }
    
    func confirm() {
        userStorage.saveSelectedTags(selectedTags)
        confirmPublisher.send(self)
        confirmPublisher.send(completion: .finished)
    }
}
