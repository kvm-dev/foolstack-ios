//
//  MockURLSession.swift
//  FoolstackTests
//
//  Created by Evgeniy Zolkin on 10.11.2023.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var response: URLResponse?
    var data: Data?
    
    func get(with url: URL) async throws -> Result<Data, Error> {
        if let response = self.response {
            return verifyResponse(data: data, response: response)
        }
        
        let fileName = "Mock_\(url.lastPathComponent)_JSON"
        guard let data = Data.fromJSON(fileName: fileName) else {
            let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
            return verifyResponse(data: nil, response: response)
        }
        
//        let jsonString = String(data: data, encoding: .utf8)!
//        print(jsonString)
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
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
