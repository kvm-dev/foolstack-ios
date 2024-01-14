//
//  TicketQuestionEntity.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

struct TicketQuestionEntity {
    let question: String
    let variants: [String]
    let answers: [Int]
    
    init(question: String, variants: [String], answers: [Int]) {
        self.question = question
        self.variants = variants
        self.answers = answers
    }
    
    init(data: TicketQuestionData) {
        self.question = data.question
        self.variants = data.variants
        self.answers = data.answers
    }
}
