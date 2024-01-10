//
//  ExaminationVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 10.01.2024.
//

import Foundation
import UIKit

@MainActor
final class ExaminationVC : UIViewController {
    
    var viewModel: ExaminationVM!
    
    var tableView: UITableView!
    var choiceButton: UIButton!
    var nextButton: UIButton!
    var finishButton: UIButton!

    init(viewModel: ExaminationVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
    }
    
    private func reloadList() {
        tableView.reloadData()
    }
    
    private func createViews() {
        self.view.backgroundColor = .themeBackgroundSecondary
        
        tableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .themeBackgroundSecondary
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        tableView.register(ExamTableCell.self, forCellReuseIdentifier: ExamTableCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        choiceButton = createConfirmButton(title: String(localized: "Choice", comment: ""), color: .themeAccent)
        choiceButton.addTarget(self, action: #selector(choiceButtonTapped), for: .touchUpInside)

        nextButton = createConfirmButton(title: String(localized: "Next", comment: ""), color: .green)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.isHidden = true

        finishButton = createConfirmButton(title: String(localized: "Finish", comment: ""), color: .blue)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        finishButton.isHidden = true
    }
    
    private func createConfirmButton(title: String, color: UIColor) -> UIButton {
        let buttonPadding: CGFloat = 12
        let button = BorderButton(backgroundColor: .themeAccent)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.pinEdges(to: view.safeAreaLayoutGuide, leading: buttonPadding, trailing: -buttonPadding, bottom: -buttonPadding)
        button.pinSize(height: 56)
        return button
    }
    
    @objc func choiceButtonTapped() {
        let result = viewModel.confirm()
        showResult(result)
    }
    
    @objc func nextButtonTapped() {
        viewModel.nextQuestion()
        tableView.reloadSections([0], with: .automatic)
        replaceButtons(buttonToShow: choiceButton, buttonToHide: nextButton)
    }
    
    @objc func finishButtonTapped() {
        viewModel.finishExam()
    }
    
    func showResult(_ result: QuestionResult) {
        if viewModel.canGoNext() {
            replaceButtons(buttonToShow: nextButton, buttonToHide: choiceButton)
        } else {
            replaceButtons(buttonToShow: finishButton, buttonToHide: choiceButton)
        }
        
        for answer in result.targetAnswers {
            let cell = tableView.cellForRow(at: IndexPath(row: answer, section: 0)) as! ExamTableCell
            cell.showBorder()
        }
        
        for answer in result.myCorrectAnswers {
            let cell = tableView.cellForRow(at: IndexPath(row: answer, section: 0)) as! ExamTableCell
            cell.highlight(isSuccess: true)
        }
        for answer in result.myWrongAnswers {
            let cell = tableView.cellForRow(at: IndexPath(row: answer, section: 0)) as! ExamTableCell
            cell.highlight(isSuccess: false)
        }
    }
    
    private func replaceButtons(buttonToShow: UIButton, buttonToHide: UIButton) {
        UIView.transition(from: buttonToHide, to: buttonToShow, duration: 0.5, options: [.showHideTransitionViews, .transitionCrossDissolve])
    }
}


extension ExaminationVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.currentQuestion.variants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = viewModel.currentQuestion.variants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ExamTableCell.reuseIdentifier, for: indexPath) as! ExamTableCell
        cell.configure(title: cellInfo)
        return cell
    }
    
}

extension ExaminationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ent = viewModel.currentQuestion.variants[indexPath.row]
        let selected = viewModel.select(answer: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! ExamTableCell
        cell.setToggled(selected)
    }
}
