//
//  RealmStorageTests.swift
//  FoolstackTests
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import XCTest
@testable import Foolstack
import RealmSwift

final class LocalStorageTests: XCTestCase {
    var sut: DataStorage!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.sut = DataStorage(config: LocalStorageConfig())
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    func giveSomeData() -> [WikiData] {
        return [
            WikiData(id: 1, imageURL: nil, ask: "Ask 1", shortAnswer: "Answer 1", fullAnswerExists: true, fullAnswer: nil),
            WikiData(id: 2, imageURL: nil, ask: "Ask 2", shortAnswer: "Answer 2", fullAnswerExists: false, fullAnswer: nil),
        ]
    }
    
    func convertRealmItemsToServerData(_ items: [WikiListEntity]) -> [WikiData] {
        items.map { WikiData(id: $0.serverId, imageURL: nil, ask: $0.ask, shortAnswer: $0.shortAnswer, fullAnswerExists: $0.fullAnswerExists, fullAnswer: nil)}//$0.fullAnswer?.content)}
    }

    func test_createNewWikis_dataCreated() async throws {
        try await Task.sleep(1.0)
        
        let data = giveSomeData()
        try await sut.addItems(data)
        let addedItems = await sut.getWikiEntities()
        
        let convertedData = convertRealmItemsToServerData(addedItems)
        XCTAssertEqual(data, convertedData)
    }


}
