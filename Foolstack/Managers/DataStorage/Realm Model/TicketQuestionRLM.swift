//
//  TicketQuestionRLM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

import RealmSwift

class TicketQuestionRLM: EmbeddedObject {
    @Persisted var question: String
    @Persisted var variants: List<String>
    @Persisted var answers: List<Int>

    convenience init(data: TicketQuestionData) {
        self.init()
        self.question = data.question
        self.variants.append(objectsIn: data.variants)
        self.answers.append(objectsIn: data.answers)
    }
}
