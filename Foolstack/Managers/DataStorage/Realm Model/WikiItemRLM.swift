//
//  WikiItemRLM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 12.11.2023.
//

import Foundation
import RealmSwift

class WikiItemRLM: Object {
    @Persisted (primaryKey: true) var serverId: Int
    @Persisted var ask: String = ""
    @Persisted var shortAnswer = ""
    @Persisted var fullAnswerExist = false
    @Persisted var fullAnswer: WikiAnswerRLM?
    //@Persisted (originProperty: "items") var tags: LinkingObjects<WikiTagRLM>
    @Persisted var tags: MutableSet<ServerKey>
    
    convenience init(_ data: WikiData) {
        self.init()
        
        self.serverId = data.id
        self.ask = data.ask
        self.shortAnswer = data.shortAnswer
        self.fullAnswerExist = data.fullAnswerExists
        if let fullAnswer = data.fullAnswer {
            self.fullAnswer = WikiAnswerRLM(content: fullAnswer)
        }
        self.tags.insert(objectsIn: data.tags)
    }
}

extension WikiItemRLM: @unchecked Sendable {}
