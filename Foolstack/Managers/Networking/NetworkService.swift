//
//  NetworkService.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 14.11.2023.
//

import Foundation

protocol NetworkService {
    func getCategories() async throws -> [CatData]?
    func getWikis(tags: [ServerKey]) async throws -> [WikiData]?
    func getTags() async throws -> [TagData]?
    func getTickets() async throws -> [TicketData]?
    func signIn(email: String) async throws -> LoginResponseData
    func sendLoginCode(code: String) async throws -> UserProfile
}


extension NetworkService {
    func decodeResult<T>(with result: Result<Data, Error>, decode: T.Type) async throws -> T where T : Decodable {
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                printToConsole("JSON error: \(error)")
                throw NetworkAPIError.invalidResponseFormat
            }
            
        case .failure(let error):
            throw error
        }
    }

}
