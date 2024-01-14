//
//  TicketEntity.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

struct TicketEntity {
    let serverId: ServerKey
    let name: String
    let questions: [TicketQuestionEntity]
    let tags: [ServerKey]

    init(id: ServerKey, name: String, questions: [TicketQuestionEntity], tags: [ServerKey]) {
        self.serverId = id
        self.name = name
        self.questions = questions
        self.tags = tags
    }
    
    init(data: TicketData) {
        self.serverId = data.id
        self.name = data.name
        self.questions = data.questions.map(TicketQuestionEntity.init)
        self.tags = data.tags
    }
}
