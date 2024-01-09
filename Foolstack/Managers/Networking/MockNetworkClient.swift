//
//  MockNetworkClient.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 14.11.2023.
//

import Foundation

class MockNetworkClient: NetworkService {
    let session: URLSessionProtocol = MockURLSession()
    let baseUrl: URL = URL(string: "https://mock_foolstack.ru/api/v1/")!

    init() {
    }
    
    private func decodeResult<T>(with result: Result<Data, Error>, decode: T.Type) async throws -> T where T : Decodable {
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkAPIError.invalidResponseFormat
            }
            
        case .failure(let error):
            throw error
        }
    }
    
    func getWikis(tags: [ServerKey]) async throws -> [WikiData]? {
        let url = URL(string: "wikis", relativeTo: baseUrl)!
        
        let apiData = try await session.get(with: url)
        let result = try await decodeResult(with: apiData, decode: [WikiData].self)
        return result.filter{ !Set($0.tags).isDisjoint(with: Set(tags)) }
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
                printToConsole("JSON parsing error: \(error.localizedDescription)")
                throw NetworkAPIError.invalidResponseFormat
            }
            
        case .failure(let error):
            throw error
        }
    }
}
