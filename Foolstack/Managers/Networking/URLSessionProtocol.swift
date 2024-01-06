//
//  URLSessionProtocol.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 10.11.2023.
//

import Foundation

protocol URLSessionProtocol: AnyObject {
  
    func get(with url: URL) async throws -> Result<Data, Error>
    //-> URLSessionTaskProtocol
}

protocol URLSessionTaskProtocol: AnyObject {
  func resume()
}


enum APIError: Error {
    case badRequest
    case serverError
    case unknown
}

extension URLSession: URLSessionProtocol {

    func get(with url: URL) async throws -> Result<Data, Error> {
        let (data, response) = try await self.data(from: url)
        return verifyResponse(data: data, response: response)
    }
    
    private func verifyResponse(data: Data, response: URLResponse) -> Result<Data, Error> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(APIError.unknown)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return .success(data)
        case 400...499:
            return .failure(APIError.badRequest)
        case 500...599:
            return .failure(APIError.serverError)
        default:
            return .failure(APIError.unknown)
            
        }
    }
}
