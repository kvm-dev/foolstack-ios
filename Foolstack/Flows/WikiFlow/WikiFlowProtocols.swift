//
//  WikiFlowProtocols.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

@MainActor
protocol WikiListView: AnyObject {
    func show(items: [WikiListEntity])
    func show(tags: [TagEntity])
}

@MainActor
protocol WikiListPresenter: AnyObject {
    func viewDidLoad(view: WikiListView)
    
    func selectTag(index: Int)
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

@MainActor
protocol WikiListRouter: AnyObject {
    func openTagList(tags: [TagEntity])
}

protocol WikiListRepo: AnyObject {
    func fetchEntities(completion: @escaping ([WikiListEntity]?, Error?) -> Void)
    func fetchTags(keys: [ServerKey]) async throws -> [TagEntity]
}


@MainActor
protocol TagListView: AnyObject {
    func show(tags: [TagEntity])
}
