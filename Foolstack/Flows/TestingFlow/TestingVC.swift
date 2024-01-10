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
        createViews()
        
        viewModel.load()
    }
    
    private func reloadList() {
        tableView.reloadData()
    }
    
    private func createViews() {
        
        tableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .themeBackgroundMain
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
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
        let percents = "56%"
        let subtitle = String(localized: "\(cellInfo.questions.count) bobs")
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
