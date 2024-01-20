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
    var db: RealmActor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.sut = DataStorage(config: MemoryStorageConfig())
        //        Task {
        //            self.db = try await RealmActor(config: LocalStorageConfig().getRealmConfig())
        //        }
    }
    
    override func tearDownWithError() throws {
        sut.clearDB()
        sut = nil
        
        try super.tearDownWithError()
    }
    
    func giveSomeData() -> [WikiData] {
        return [
            WikiData(id: 1, imageURL: nil, ask: "Ask 1", shortAnswer: "Answer 1", fullAnswerExists: true, fullAnswer: nil, tags: [1,3,5]),
            WikiData(id: 2, imageURL: nil, ask: "Ask 2", shortAnswer: "Answer 2", fullAnswerExists: false, fullAnswer: nil, tags: [3,6]),
        ]
    }
    
    func createSomeTags() -> [TagData] {
        let tags: [TagData] = (1...6).map{i in TagData(id: i, name: "Tag \(i)", parent: 1)}
        return tags
    }
    
    func test_createNewWikis_dataCreated() async throws {
        //try await Task.sleep(1.0)
        
        let data = giveSomeData()
        let tags = Array(Set(data.flatMap{$0.tags}))
        _ = await sut.addItems(data)
        let addedItems = await sut.getWikiEntities(for: tags)
        
        let convertedData = convertRealmItemsToServerData(addedItems)
        XCTAssertEqual(data, convertedData)
    }
    
    func test_db() async throws {
        //        try await Task.sleep(1.0)
        let db = RealmActor(config: MemoryStorageConfig().getRealmConfig())
        let data = giveSomeData()
        let tags = Array(Set(data.flatMap{$0.tags}))
        _ = try await db.addWikiItems(data)
        let addedItems = try await db.getWikiEntities(for: tags)
        
        let convertedData = convertRealmItemsToServerData(addedItems)
        XCTAssertEqual(data, convertedData)
    }
    
    func test_addTagsToStorage() async {
        let data = createSomeTags()
        _ = await sut.addTags(data)
        
        let tagsIds = data.map{$0.id}
        let addedTags = await sut.getTagEntities(for: tagsIds)
        
        let convertedData = convertRealmTagsToServerData(addedTags)
        XCTAssertEqual(data, convertedData)
    }

    func test_addWikiItemsToTags() async {
        let data = createSomeTags()
        _ = await sut.addTags(data)
        
        let itemData = giveSomeData()
        let itemsTagIds = Array(Set(itemData.flatMap{$0.tags}))

        _ = await sut.addItems(itemData)
        let itemsTags = await sut.getTagEntities(for: [])
        let filteredRealmTags = itemsTags.filter{ itemsTagIds.contains($0.serverId) }
        let filteredTagsData = data.filter{ itemsTagIds.contains($0.id) }
        
        let wikiEnts = await sut.getWikiEntities(for: itemsTagIds)

        let convertedData = convertRealmTagsToServerData(filteredRealmTags)
        let convertedWikiData = convertRealmItemsToServerData(wikiEnts)
        
        XCTAssertEqual(filteredTagsData, convertedData)
        XCTAssertEqual(itemData, convertedWikiData)
    }
}
