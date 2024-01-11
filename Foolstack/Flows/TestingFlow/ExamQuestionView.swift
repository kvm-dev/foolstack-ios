//
//  ExamQuestionView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 11.01.2024.
//

import UIKit

class ExamQuestionView: UIView {
    var onClose: (() -> Void)?
    
    private var headerBar: HeaderBar!
    private var tableView: UITableView!
    private var choiceButton: UIButton!
    private var nextButton: UIButton!
    private var timerLabel: UILabel!
    
    private var viewModel: ExamQuestionVM!
    
    init(viewModel: ExamQuestionVM, frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = viewModel
        
        createHeader()
        createContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createHeader() {
        headerBar = HeaderBar(withSlider: false)
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerBar)
        headerBar.color = .themeHeader
        headerBar.heightConstraint.constant = 44
        headerBar.pinEdges(to: self, leading: 12, trailing: -12, top: 12)
        
        let closeButton = UIButton.customClose()
        headerBar.addLeftButton(button: closeButton)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        
        headerBar.titleLabel.text = viewModel.title
        
    }
    
    private func createContent() {
        let titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = CustomFonts.defaultMedium(size: 14)
        titleLabel.textColor = .themeTextViewTitle
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = viewModel.question.question
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 16),
        ])
        
        let divider = UIView()
        addSubview(divider)
        divider.backgroundColor = .themeHeader
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            divider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])

        let timerView = UIView()
        timerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timerView)
        NSLayoutConstraint.activate([
            timerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            timerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 24),
            timerView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
        ])
        
        let timerImage = UIImageView(image: UIImage(named: "clock"))
        timerImage.translatesAutoresizingMaskIntoConstraints = false
        timerView.addSubview(timerImage)
        NSLayoutConstraint.activate([
            timerImage.leadingAnchor.constraint(equalTo: timerView.leadingAnchor, constant: 0),
            timerImage.topAnchor.constraint(equalTo: timerView.topAnchor, constant: 0),
            timerImage.widthAnchor.constraint(equalToConstant: 48),
            timerImage.heightAnchor.constraint(equalToConstant: 48),
            timerView.bottomAnchor.constraint(equalTo: timerImage.bottomAnchor)
        ])

        timerLabel = UILabel()
        addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.font = CustomFonts.defaultMedium(size: 14)
        timerLabel.textColor = .themeTextMain
        timerLabel.numberOfLines = 1
        timerLabel.text = "30 seconds left"
        
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: timerImage.trailingAnchor, constant: 12),
            timerLabel.trailingAnchor.constraint(equalTo: timerView.trailingAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),
        ])

        choiceButton = createConfirmButton(title: String(localized: "Choice", comment: ""), color: .themeAccent)
        choiceButton.addTarget(self, action: #selector(choiceButtonTapped), for: .touchUpInside)
        
        nextButton = createConfirmButton(title: String(localized: "Next", comment: ""), color: .green)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.isHidden = true
        
        tableView = UITableView(frame: .zero, style: .plain)
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = nil//.themeBackgroundSecondary
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: self.choiceButton.topAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        tableView.register(ExamTableCell.self, forCellReuseIdentifier: ExamTableCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func createConfirmButton(title: String, color: UIColor) -> UIButton {
        let buttonPadding: CGFloat = 12
        let button = BorderButton(backgroundColor: color)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.pinEdges(to: self, leading: buttonPadding, trailing: -buttonPadding, bottom: -buttonPadding)
        button.pinSize(height: 56)
        return button
    }
    
    private func replaceButtons(buttonToShow: UIButton, buttonToHide: UIButton) {
        //UIView.transition(from: buttonToHide, to: buttonToShow, duration: 0.5, options: [.showHideTransitionViews, .transitionFlipFromTop])
        buttonToShow.isHidden = false
        buttonToShow.transform = CGAffineTransform(translationX: self.superview!.bounds.width, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            buttonToShow.transform = CGAffineTransform.identity
            buttonToHide.transform = CGAffineTransform(translationX: -self.superview!.bounds.width, y: 0)
        } completion: { fin in
            buttonToHide.isHidden = true
        }
    }
    
    private func reloadList() {
        tableView.reloadData()
    }
    
    @objc func choiceButtonTapped() {
        let result = viewModel.confirm()
        showResult(result)
    }
    
    @objc func nextButtonTapped() {
        viewModel.goNext()
    }
    
    @objc func closePressed() {
        onClose?()
    }
    
    func showResult(_ result: QuestionResult) {
        replaceButtons(buttonToShow: nextButton, buttonToHide: choiceButton)
        
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
    
}

extension ExamQuestionView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.question.variants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = viewModel.question.variants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ExamTableCell.reuseIdentifier, for: indexPath) as! ExamTableCell
        cell.configure(title: cellInfo)
        return cell
    }
    
}

extension ExamQuestionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !viewModel.isMultiSelection {
            tableView.visibleCells.compactMap{$0 as? ExamTableCell}.forEach{
                $0.setToggled(false, isRadioButton: true)
            }
        }
        let selected = viewModel.select(answer: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! ExamTableCell
        cell.setToggled(selected, isRadioButton: !viewModel.isMultiSelection)
    }
}
