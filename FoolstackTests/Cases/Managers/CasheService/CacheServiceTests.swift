//
//  CacheServiceTests.swift
//  FoolstackTests
//
//  Created by Evgeniy Zolkin on 14.11.2023.
//

import XCTest
@testable import Foolstack

final class CacheServiceTests: XCTestCase {
    var sut: DataCacheService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DataCacheImp(
            network: MockNetworkClient(),
            storageConfig: MemoryStorageConfig())
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_getTagsFromNetworkAndAddToStorage() async throws {
        let cache = sut as! DataCacheImp
        let networkDataSrc = try await cache.network.getTags()
        
        let targetEnts = try await sut.getTags(for: [])
        
        let targetData = convertRealmTagsToServerData(targetEnts)
        XCTAssertEqual(targetData, networkDataSrc)
    }

    func test_getWikiFromNetworkAndAddToStorage() async throws {
//        let items = [
//            WikiData(id: 1, imageURL: nil, ask: "Ask 1", shortAnswer: "Answer 1", fullAnswerExists: true, fullAnswer: nil, tags: [1,3,5]),
//            WikiData(id: 2, imageURL: nil, ask: "Ask 2", shortAnswer: "Answer 2", fullAnswerExists: false, fullAnswer: nil, tags: [3,6]),
//        ]
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        let jsonData = try encoder.encode(items)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        print(jsonString)

        let targetTagsIds = Array(1...3)
        let cache = sut as! DataCacheImp
        let networkDataSrc = try await cache.network.getWikis(tags: targetTagsIds)
        
        _ = try await sut.getTags(for: [])
        let targetEnts = try await sut.getWikis(tags: targetTagsIds)

        let targetData = convertRealmItemsToServerData(targetEnts)
        XCTAssertEqual(targetData, networkDataSrc)
    }
}
