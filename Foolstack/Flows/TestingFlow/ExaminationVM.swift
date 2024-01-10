//
//  ExaminationVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 10.01.2024.
//

import Foundation

struct QuestionResult {
    let isSuccess: Bool
    let targetAnswers: [Int]
    let myCorrectAnswers: [Int]
    let myWrongAnswers: [Int]
}

@MainActor
final class ExaminationVM {
    //var onQuestionResult: ((QuestionResult) -> Void)?
    
    let ticket: TicketEntity
    var currentQuestionNumber: Int = 0
    
    private var examResults: [Int : Bool] = [:]
    
    private let cacheService: DataCacheService
    private let userStorage: UserStorage

    init(ticket: TicketEntity, cacheService: DataCacheService, userStorage: UserStorage) {
        self.cacheService = cacheService
        self.userStorage = userStorage
        self.ticket = ticket
        
    }

    var currentQuestion: TicketQuestionEntity {
        ticket.questions[currentQuestionNumber]
    }
    
    private var selectedAnswers = Set<Int>()

    func select(answer: Int) -> Bool {
        if let index = selectedAnswers.firstIndex(of: answer) {
            selectedAnswers.remove(at: index)
            return false
        } else {
            selectedAnswers.insert(answer)
            return true
        }
    }
    
    var isMultiSelection: Bool {
        currentQuestion.answers.count > 1
    }
    
    func confirm() -> QuestionResult {
        let targetAnswers = currentQuestion.answers.sorted()
        let myAnswers = selectedAnswers.sorted()

        let success = targetAnswers.elementsEqual(myAnswers)
        examResults[currentQuestionNumber] = success
        
        return QuestionResult(
            isSuccess: success,
            targetAnswers: targetAnswers,
            myCorrectAnswers: myAnswers.filter { targetAnswers.contains($0) },
            myWrongAnswers: myAnswers.filter { !targetAnswers.contains($0) }
        )
    }
    
    func canGoNext() -> Bool {
        currentQuestionNumber < ticket.questions.count - 1
    }
    
    func nextQuestion() {
        currentQuestionNumber += 1
        selectedAnswers.removeAll()
    }
    
    func finishExam() {
        
    }
}


class ExamResult {
    
}
