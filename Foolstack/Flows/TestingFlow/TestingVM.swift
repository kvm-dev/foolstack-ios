//
//  TestingVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

import Foundation

@MainActor
final class TestingVM {
    var onItemsLoaded: (() -> Void)?

    private let cacheService: DataCacheService
    private let userStorage: UserStorage
    private var selectedTags: [ServerKey] = []
    private(set) var items: [TicketEntity] = []
    
    init(cacheService: DataCacheService, userStorage: UserStorage) {
        self.cacheService = cacheService
        self.userStorage = userStorage
    }
    
    func load() {
        loadTags()
        loadEntities()
    }
    
    private func loadTags() {
        self.selectedTags = userStorage.getSelectedTags()
        self.selectedTags = [1,3,6,8]
    }

    func loadEntities() {
        Task { [weak self] in
            guard let self = self else {return}
            do {
                let items = try await self.cacheService.getTickets(for: selectedTags)
                self.fetchEntitiesSuccess(items: items)
            } catch {
                self.fetchEntitiesFailure(error: error)
            }
        }
    }
    
    func fetchEntitiesSuccess(items: [TicketEntity]) {
        self.items = items
        onItemsLoaded?()
    }
    
    func fetchEntitiesFailure(error: Error) {
        
    }
    
    func createExamination(ticketIndex: Int) -> ExaminationVM {
        let ticket = items[ticketIndex]
        let vm = ExaminationVM(ticket: ticket, cacheService: cacheService, userStorage: userStorage)
        return vm
    }
}
