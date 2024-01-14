//
//  NetworkService.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 14.11.2023.
//

protocol NetworkService {
    func getWikis(tags: [ServerKey]) async throws -> [WikiData]?
    
    func getTags() async throws -> [TagData]?
    func getTickets() async throws -> [TicketData]?
}
