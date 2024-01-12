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

struct ExamResult {
    let correctAnswers: Int
    let wrongAnswers: Int
}

@MainActor
final class ExaminationVM {
    var onShowNextQuestion: ((ExamQuestionVM) -> Void)?
    var onShowExamResult: ((ExamResult) -> Void)?

    let ticket: TicketEntity
    var currentQuestionNumber: Int = -1
    
    private var examResults: [Int : Bool] = [:]
    private var currentQuestionVM: ExamQuestionVM?
    
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
    
    private func createCurrentQuestionViewModel() -> ExamQuestionVM {
        let title = "\(currentQuestionNumber+1) / \(ticket.questions.count)"
        let vm = ExamQuestionVM(question: currentQuestion, title: title)
        vm.onFinish = { [unowned self] result in
            self.questionFinished(result: result)
        }
        currentQuestionVM = vm
        return vm
    }
    
    private func questionFinished(result: QuestionResult) {
        addQuestionResult(result)
        goNext()
    }
    
    func goNext() {
        if canGoNext() {
            nextQuestion()
        } else {
            finishExam()
        }
    }
    
    private func canGoNext() -> Bool {
        currentQuestionNumber < ticket.questions.count - 1
    }
    
    private func nextQuestion() {
        currentQuestionNumber += 1
        let vm = createCurrentQuestionViewModel()
        currentQuestionVM = vm
        onShowNextQuestion?(vm)
    }
    
    private func addQuestionResult(_ result: QuestionResult) {
        examResults[currentQuestionNumber] = result.isSuccess
    }
    
    func finishExam() {
        let result = ExamResult(
            correctAnswers: examResults.filter{ $0.value == true }.count,
            wrongAnswers: examResults.filter{ $0.value == false }.count)
        onShowExamResult?(result)
        
        let percent = Double(result.correctAnswers) / Double(examResults.count) * 100
        userStorage.saveTicketResult(ticketId: ticket.serverId, completionPercent: Int(percent))
    }
}


