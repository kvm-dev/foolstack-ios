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
    
    func getCategories() async throws -> [CatData]? {
        let url = URL(string: "cats", relativeTo: baseUrl)!
        
        let apiData = try await session.get(with: url)
        let result = try await decodeResult(with: apiData, decode: CatResponseData.self)
        if result.success {
            return result.professions
        } else {
            throw NetworkAPIError.responseFailure(result.errorMsg)
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
    
    //MARK: AUTH
    
    func signIn(email: String) async throws -> LoginResponseData {
        let url = URL(string: "signIn", relativeTo: baseUrl)!
        
        let apiData = try await session.get(with: url)
        try await Task.sleep(2.0)
        let result = try await decodeResult(with: apiData, decode: LoginResponseData.self)
        if result.success {
            return result
        } else {
            throw NetworkAPIError.responseFailure(result.errorMsg ?? "Unknown error")
        }
    }
    
    func sendLoginCode(code: String) async throws -> UserProfile {
        let url = URL(string: "sendCode", relativeTo: baseUrl)!
//        throw NetworkAPIError.responseFailure("Test error")

        let apiData = try await session.get(with: url)
        try await Task.sleep(2.0)
        let result = try await decodeResult(with: apiData, decode: UserResponseData.self)
        if result.success {
            return UserProfile(data: result)
        } else {
            throw NetworkAPIError.responseFailure(result.errorMsg ?? "Unknown error")
        }
    }
    
}
