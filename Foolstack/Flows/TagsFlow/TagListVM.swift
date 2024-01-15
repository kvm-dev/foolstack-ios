//
//  TagListVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 04.01.2024.
//

import Foundation

final class TagListVM {
    var onConfirm: (() -> Void)?
    @Published var isConfirmEnabled = false

    private(set) var items: [TagEntity]
    private let cacheService: DataCacheService
    private let userStorage: UserStorage
    
    private var selectedTags: [Int] = [] {
        didSet {
            isConfirmEnabled = !selectedTags.isEmpty
        }
    }
    
    init(items: [TagEntity], cacheService: DataCacheService, userStorage: UserStorage) {
        self.cacheService = cacheService
        self.userStorage = userStorage
        self.items = items
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
        onConfirm?()
    }
}
