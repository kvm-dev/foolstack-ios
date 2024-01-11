//
//  ExamQuestionVM.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.01.2024.
//

class ExamQuestionVM {
    var onFinish: ((QuestionResult) -> Void)?
    let question: TicketQuestionEntity
    let title: String
    
    private var questionResult: QuestionResult!
    
    init(question: TicketQuestionEntity, title: String) {
        self.question = question
        self.title = title
    }
    
    private var selectedAnswers = Set<Int>()

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
    
}
