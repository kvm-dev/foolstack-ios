//
//  NetworkClientTests.swift
//  FoolstackTests
//
//  Created by Evgeniy Zolkin on 10.11.2023.
//

import XCTest
@testable import Foolstack

final class NetworkClientTests: XCTestCase {
    var mockSession: MockURLSession!
    var baseUrl: URL!
    var sut: NetworkService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockSession = MockURLSession()
        baseUrl = URL(string: "https://foolstack.ru/api/v1/")
        sut = MockNetworkClient()
    }

    override func tearDownWithError() throws {
        mockSession = nil
        sut = nil
        baseUrl = nil
        
        try super.tearDownWithError()
    }

    func test_request() async throws {
        
        guard let data = Data.fromJSON(fileName: "Mock_wikis_JSON") else {
            XCTFail()
            return
        }
        
        let jsonString = String(data: data, encoding: .utf8)!
        print(jsonString)
        
        let decoder = JSONDecoder()
        let items = try decoder.decode([WikiData].self, from: data)
        
        let url: URL = baseUrl
        let session = mockSession as MockURLSession
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.data = data
        let resultItems = try await sut.getWikis(tags: [])
        
        XCTAssertNotNil(resultItems)
        XCTAssertEqual(6, resultItems?.count ?? 0)
    }
    
    func test_get_receivedError() async throws {
        let url: URL = URL(string: "wikis", relativeTo: baseUrl)!
        let session = mockSession as MockURLSession
        session.response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        var result = try await session.get(with: url)
        
        assertIsFailure(result) { XCTAssertEqual($0 as! APIError, APIError.badRequest) }

        session.response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        result = try await session.get(with: url)
        
        assertIsFailure(result) { XCTAssertEqual($0 as! APIError, APIError.serverError) }

        session.response = HTTPURLResponse(url: url, statusCode: 700, httpVersion: nil, headerFields: nil)
        result = try await session.get(with: url)
        
        assertIsFailure(result) { XCTAssertEqual($0 as! APIError, APIError.unknown) }

        //        switch result {
//        case .success(_):
//            XCTFail("Should not be success")
//        case .failure(let failure as APIError):
//            XCTAssertEqual(failure, APIError.badRequest)
//        case .failure(_):
//            XCTFail("Unknown error")
//        }
    }

}
