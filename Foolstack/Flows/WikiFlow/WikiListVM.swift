//
//  WikiListVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 06.01.2024.
//

import Foundation
import Combine

@MainActor
class WikiListVM {
    var onItemsLoaded: (() -> Void)?
    @Published var searchText: String = ""

    private let cacheService: DataCacheService
    private let userStorage: UserStorage
    
    private var selectedTags: [ServerKey] = []
    private(set) var items: [WikiListEntity] = []
    @Published var filteredItems: [WikiListEntity] = []

    var subscription = Set<AnyCancellable>()

    init(cacheService: DataCacheService, userStorage: UserStorage) {
        self.cacheService = cacheService
        self.userStorage = userStorage

        $searchText.dropFirst()
          .sink { [unowned self] text in
            filterItems(text)
          }.store(in: &subscription)
    }
    
    func load() {
        loadTags()
        getEntities()
    }
    
    private func loadTags() {
        self.selectedTags = userStorage.getSelectedTags()
        self.selectedTags = [1,3,6,8]
    }

    private func getEntities() {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                let items = try await self.cacheService.getWikis(tags: selectedTags)
                self.fetchEntitiesSuccess(items: items)
            } catch {
                self.fetchEntitiesFailure(error: error)
            }
        }
    }

    private func fetchEntitiesSuccess(items: [WikiListEntity]) {
        self.items = items
        filterItems(searchText)
        onItemsLoaded?()
    }
    
    func fetchEntitiesFailure(error: Error) {
        
    }
    
    func filterItems(_ searchText: String) {
      filteredItems = items.filter {
        if searchText.isEmpty { return true }
          return $0.ask.lowercased().contains(searchText.lowercased())
      }
      //sortItems()
    }

}
