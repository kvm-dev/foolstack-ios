//
//  MockURLSession.swift
//  FoolstackTests
//
//  Created by Evgeniy Zolkin on 10.11.2023.
//

@testable import Foolstack
import Foundation

class MockURLSession: URLSessionProtocol {
    var response: URLResponse?
    var data: Data?
    
    func get(with url: URL) async throws -> Result<Data, Error> {
        
        return verifyResponse(data: data, response: response)
    }
    
    private func verifyResponse(data: Data?, response: URLResponse?) -> Result<Data, Error> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(APIError.unknown)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return .success(data ?? Data())
        case 400...499:
            return .failure(APIError.badRequest)
        case 500...599:
            return .failure(APIError.serverError)
        default:
            return .failure(APIError.unknown)
            
        }
    }

}
