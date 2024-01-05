//
//  TagListVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 04.01.2024.
//

import Foundation

final class TagListVM {
    private(set) var items: [TagEntity]
    private let cacheService: DataCacheService
    
    private var selectedTags: [Int] = []
    
    init(items: [TagEntity], cacheService: DataCacheService) {
        self.cacheService = cacheService
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
}
