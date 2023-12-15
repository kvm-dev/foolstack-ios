//
//  TagsListVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import Foundation
import UIKit

final class TagListVC: UIViewController, TagListView {
    private var headerBar: HeaderBar!
    private weak var tableView: UITableView!
    
    var presenter: WikiListPresenter!
    
    private var tags: [TagEntity] = []
    
    init(tags: [TagEntity]) {
        super.init(nibName: nil, bundle: nil)
        
        self.tags = tags
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configureHeader()
        setupView()
        
        
    }
    
    private func setupView() {
        self.view.backgroundColor = .yellow
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = false
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .brown
        
        tableView.pinEdges(to: view.safeAreaLayoutGuide, leading: 0, trailing: 0, top: 0, bottom: -8)
        //tableView.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 0).isActive = true
        
        tableView.register(SimpleTableCell.self, forCellReuseIdentifier: SimpleTableCell.CellID)
        
    }
    
    private func configureHeader() {
        headerBar = HeaderBar(withSlider: true)
        view.addSubview(headerBar)
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        headerBar.pinEdges(to: view.safeAreaLayoutGuide, leading: 8, trailing: -8, top: 0)
        
        headerBar.titleLabel.text = NSLocalizedString("SUBSCRIPTIONS", comment: "")
        
        let backButton = UIButton.customClose()
        headerBar.addLeftButton(button: backButton)
        backButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
    }
    
    @objc func closePressed(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    func show(tags: [TagEntity]) {
        self.tags = tags
        tableView.reloadData()
    }
}


extension TagListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //updateFooter(visible: !products.isEmpty)
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cell for row at: section \(indexPath.section), row \(indexPath.row)")
        let cellInfo = tags[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTableCell.CellID, for: indexPath) as! SimpleTableCell
        cell.configure(leftImage: IconNames.checkbox, title: cellInfo.name)
        return cell
    }
    
    
    
}

extension TagListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let product = products[indexPath.row]
        print("TagListVC. didSelectRow")
    }
}
