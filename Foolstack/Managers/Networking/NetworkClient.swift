//
//  NetworkClient.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 10.11.2023.
//

import Foundation

enum NetworkAPIError: Error {
    case nilRequest
    case invalidResponseFormat
}

class NetworkClient: NetworkService {
    static let shared = NetworkClient(
        baseUrl: URL(string: "https://foolstack.ru/api/v1/")!, session: URLSession(configuration: .default))
    
    let baseUrl: URL// = "https://foolstack.ru/api/v1/"
    let session: URLSessionProtocol// = URLSession(configuration: .default)
    
    init(baseUrl: URL, session: URLSessionProtocol) {
        self.baseUrl = baseUrl
        self.session = session
    }
    
    func getWikis(tags: [ServerKey]) async throws -> [WikiData]? {
        let url = URL(string: "wikis", relativeTo: baseUrl)!
        
        let apiData = try await session.get(with: url)
        switch apiData {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                return try decoder.decode([WikiData].self, from: data)
            } catch {
                throw NetworkAPIError.invalidResponseFormat
            }
            
        case .failure(let error):
            throw error
        }
    }
    
    func getTags() async throws -> [TagData]? {
        let url = URL(string: "tags", relativeTo: baseUrl)!
        
        let apiData = try await session.get(with: url)
        switch apiData {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                return try decoder.decode([TagData].self, from: data)
            } catch {
                throw NetworkAPIError.invalidResponseFormat
            }
            
        case .failure(let error):
            throw error
        }
    }
    
    func getTickets() async throws -> [TicketData]? {
        let url = URL(string: "tickets", relativeTo: baseUrl)!
        
        let apiData = try await session.get(with: url)
        switch apiData {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                return try decoder.decode([TicketData].self, from: data)
            } catch {
                throw NetworkAPIError.invalidResponseFormat
            }
            
        case .failure(let error):
            throw error
        }
    }
}
