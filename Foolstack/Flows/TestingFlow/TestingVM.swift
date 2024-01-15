//
//  TestingVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

import Foundation
import Combine

@MainActor
final class TestingVM {
    var onItemsLoaded: (() -> Void)?

    private let cacheService: DataCacheService
    private let userStorage: UserStorage
    private var selectedTags: [ServerKey] = []
    private(set) var items: [TicketEntity] = []
    private(set) var completePercents: [Int : Int] = [:]
    var subscriptions = Set<AnyCancellable>()
    
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
    
    func loadResults() {
        completePercents = userStorage.getTicketsResults()
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
    
    func getTicketCompletionPercents(ticketId: Int) -> Int {
        return completePercents[ticketId] ?? 0
    }
    
    func createTagsViewModel() -> TagListVM {
        let tagsVM = TagListVM(items: [], cacheService: cacheService, userStorage: userStorage)
        tagsVM.confirmPublisher
            .sink { [weak self] tagsVM in
                self?.tagsSelected(tagsVM.selectedTags)
            }
            .store(in: &subscriptions)
        return tagsVM
    }
    
    private func tagsSelected(_ tags: [ServerKey]) {
        userStorage.saveSelectedTags(tags)
        load()
    }
}
