//
//  TicketRLM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

import RealmSwift

class TicketRLM: Object {
    @Persisted (primaryKey: true) var serverId: Int
    @Persisted var name = ""
    @Persisted var questions: List<TicketQuestionRLM>
    @Persisted var tags: MutableSet<ServerKey>

    convenience init(_ data: TicketData) {
        self.init()
        self.serverId = data.id
        self.name = data.name
        self.questions.append(objectsIn: data.questions.map(TicketQuestionRLM.init))
        self.tags.insert(objectsIn: data.tags)
    }
}

