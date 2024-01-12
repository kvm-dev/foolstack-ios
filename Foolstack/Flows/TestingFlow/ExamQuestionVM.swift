//
//  ExamQuestionVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.01.2024.
//

import Foundation
import Combine

fileprivate let kQuestionTimerMax: Int = 5

@MainActor
class ExamQuestionVM {
    var onFinish: ((QuestionResult) -> Void)?
    var onTimerFinished: (() -> Void)?
    
    let question: TicketQuestionEntity
    let title: String
    @Published var isConfirmEnabled = false
    @Published var timerText: String?
    
    private(set) var questionResult: QuestionResult!
    private var timerSubscription: AnyCancellable?
    private var secondsLeft = kQuestionTimerMax
    
    init(question: TicketQuestionEntity, title: String) {
        self.question = question
        self.title = title
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.launchTimer()
        }
    }
    
    private var selectedAnswers = Set<Int>() {
        didSet {
            isConfirmEnabled = !selectedAnswers.isEmpty
        }
    }
    
    func select(answer: Int) -> Bool {
        if isMultiSelection {
            if let index = selectedAnswers.firstIndex(of: answer) {
                selectedAnswers.remove(at: index)
                return false
            } else {
                selectedAnswers.insert(answer)
                return true
            }
        } else {
            selectedAnswers.removeAll()
            selectedAnswers.insert(answer)
            return true
        }
    }
    
    var isMultiSelection: Bool {
        question.answers.count > 1
    }
    
    func confirm() -> QuestionResult {
        let targetAnswers = question.answers.sorted()
        let myAnswers = selectedAnswers.sorted()
        
        let success = targetAnswers.elementsEqual(myAnswers)
        
        questionResult = QuestionResult(
            isSuccess: success,
            targetAnswers: targetAnswers,
            myCorrectAnswers: myAnswers.filter { targetAnswers.contains($0) },
            myWrongAnswers: myAnswers.filter { !targetAnswers.contains($0) }
        )
        
        return questionResult
    }
    
    func goNext() {
        onFinish?(questionResult)
    }
    
    private func launchTimer() {
        secondsLeft = kQuestionTimerMax
        self.setTimerButtonText(seconds: secondsLeft)
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timerSubscription = timer.sink { [weak self] output in
            guard let self = self else {return}
            self.secondsLeft -= 1
            //print("Seconds left \(self.secondsLeft)")
            self.setTimerButtonText(seconds: self.secondsLeft)
            if self.secondsLeft <= 0 {
                self.timerFinished()
            }
        }
    }
    
    private func setTimerButtonText(seconds: Int) {
        let text = String(localized: "\(secondsLeft) seconds left")
        timerText = text
    }
    
    private func timerFinished() {
        self.timerSubscription?.cancel()
        self.timerSubscription = nil
        self.onTimerFinished?()
    }
    
}
