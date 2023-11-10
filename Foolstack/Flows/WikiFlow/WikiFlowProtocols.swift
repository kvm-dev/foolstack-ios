//
//  WikiFlowProtocols.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

protocol WikiListView: AnyObject {
    func show(items: [WikiListEntity])
}

protocol WikiListPresenter: AnyObject {
    func viewDidLoad(view: WikiListView)
}

protocol WikiListInteractorInput: AnyObject {
    func fetchEntities()
}

protocol WikiListInteractorOutput: AnyObject {
    func fetchEntitiesSuccess(items: [WikiListEntity])
    func fetchEntitiesFailure(error: Error)
}

protocol WikiListRouter: AnyObject {
}

protocol WikiListRepo: AnyObject {
    func fetchEntities(completion: @escaping ([WikiListEntity]?, Error?) -> Void)
}
