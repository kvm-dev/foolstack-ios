//
//  URLSessionProtocolTests.swift
//  FoolstackTests
//
//  Created by Evgeniy Zolkin on 10.11.2023.
//

import XCTest
@testable import Foolstack

final class URLSessionProtocolTests: XCTestCase {
    var session: URLSession!
    var baseUrl: URL!

    override func setUpWithError() throws {
        try super.setUpWithError()
        session = URLSession(configuration: .default)
        baseUrl = URL(string: "http://fake.example.com/")
    }

    override func tearDownWithError() throws {
        session = nil
        baseUrl = nil
        
        try super.tearDownWithError()
    }

    func test_URLSession_conformsTo_URLSessionProtocol() {
      XCTAssertTrue((session as AnyObject) is URLSessionProtocol)
    }


}
