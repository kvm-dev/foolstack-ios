//
//  TestingVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 08.01.2024.
//

import Foundation
import UIKit

@MainActor
final class TestingVC : UIViewController {
    
    var viewModel: TestingVM!
    
    var headerBar: HeaderBar!
    var tableView: UITableView!
    
    init(viewModel: TestingVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.viewModel.onItemsLoaded = { [unowned self] in
            self.reloadList()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupView()
        
        viewModel.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadResults()
        reloadList()
    }
    
    private func reloadList() {
        tableView.reloadData()
    }
    
    private func setupHeader() {
        headerBar = HeaderBar(withSlider: false)
        view.addSubview(headerBar)
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        headerBar.color = .clear
//        headerBar.titleLabel.font = CustomFonts.defaultMedium(size: 22)
//        headerBar.titleLabel.textColor = .themeTextViewTitle
        headerBar.pinEdges(to: view.safeAreaLayoutGuide, leading: 12, trailing: -12, top: 12)
        
//        headerBar.titleLabel.text = String(localized: "Knowledge area", comment: "")
        
        let filterButton = UIButton.custom(iconName: .filter)
        filterButton.tintColor = .themeTextViewTitle
        filterButton.backgroundColor = .themeHeader
        filterButton.layer.cornerRadius = 8
        headerBar.addRightButton(button: filterButton)
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
    }
    
    private func setupView() {
        self.view.backgroundColor = .themeBackgroundMain
        
        tableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .themeBackgroundMain
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.headerBar.bottomAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        tableView.register(TestingTableCell.self, forCellReuseIdentifier: TestingTableCell.CellID)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func startExamination(ticketIndex: Int) {
        let vm = viewModel.createExamination(ticketIndex: ticketIndex)
        let vc = ExaminationVC(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func filterPressed() {
        let vm = viewModel.createTagsViewModel()
        let vc = TagListVC(viewModel: vm)
        vm.confirmPublisher
            .sink(receiveValue: { [weak vc] _ in
                vc?.dismiss(animated: true)
            })
            .store(in: &viewModel.subscriptions)

        self.present(vc, animated: true)
    }
}


extension TestingVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cell for row at: section \(indexPath.section), row \(indexPath.row)")
        let cellInfo = viewModel.items[indexPath.row]
        let percent = viewModel.getTicketCompletionPercents(ticketId: cellInfo.serverId)
        let percents = "\(percent)%"
        let subtitle = String(localized: "\(cellInfo.questions.count) questions")
        let subtitle2 = "30 сек на ответ"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TestingTableCell.CellID, for: indexPath) as! TestingTableCell
        cell.configure(title1: cellInfo.name, title2: percents, subtitle1: subtitle, subtitle2: subtitle2)
        return cell
    }
    
}

extension TestingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.startExamination(ticketIndex: indexPath.row)
    }
}
