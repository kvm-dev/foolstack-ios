//
//  WikiFlowProtocols.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

protocol WikiListView: AnyObject {
    func show(items: [WikiListEntity])
    func show(tags: [TagEntity])
}

@MainActor
protocol WikiListPresenter: AnyObject {
    func viewDidLoad(view: WikiListView)
}

@MainActor
protocol WikiListInteractorInput: AnyObject {
    func fetchEntities()
    func fetchTags(keys: [ServerKey])
}

@MainActor
protocol WikiListInteractorOutput: AnyObject {
    func fetchEntitiesSuccess(items: [WikiListEntity])
    func fetchEntitiesFailure(error: Error)
    
    func fetchTagsSuccess(items: [TagEntity])
    func fetchTagsFailure(error: Error)
}

protocol WikiListRouter: AnyObject {
}

protocol WikiListRepo: AnyObject {
    func fetchEntities(completion: @escaping ([WikiListEntity]?, Error?) -> Void)
    func fetchTags(keys: [ServerKey]) async throws -> [TagEntity]
}
