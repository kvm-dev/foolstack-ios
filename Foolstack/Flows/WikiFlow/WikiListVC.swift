//
//  WikiListVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 03.11.2023.
//

import Foundation
import UIKit
import Combine

@MainActor
final class WikiListVC : UIViewController {
    
    var viewModel: WikiListVM!
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<ListSection, ListItem>!
    private var searchBar: SearchBarView!

    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: WikiListVM) {
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
    
    private func createViews() {
        self.view.backgroundColor = .themeBackgroundMain
        
        searchBar = SearchBarView()
        view.addSubview(searchBar)
        //searchBar.backgroundColor = .orange
        searchBar.placeholder = String(localized: "Search", comment: "")
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let searchPublisher = searchBar.$searchText.dropFirst()
          .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
          .share()
        
        searchPublisher
          .assign(to: &viewModel.$searchText)
        
        searchPublisher.sink(receiveValue: { [weak self] _ in
          self?.reloadList()
        }).store(in: &subscriptions)

        createCollectionView()
    }
    
    private func createCollectionView() {
        var config = UICollectionLayoutListConfiguration(appearance: UICollectionLayoutListConfiguration.Appearance.plain)
        config.backgroundColor = .themeBackgroundMain
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        // CollectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        //collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = nil//.themeBackgroundMain
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        typealias CellReg = UICollectionView.CellRegistration
        let headerCellReg = CellReg<UICollectionViewListCell, String> { cell, ip, item in
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = item
            contentConfig.textProperties.font = CustomFonts.SFSemibold.font(size: .fontMainSize)
            contentConfig.textProperties.color = .themeTextSecondary
            cell.contentConfiguration = contentConfig
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header, tintColor: .themeTextSecondary)
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
            
            var bgrd = UIBackgroundConfiguration.listPlainCell()
            bgrd.backgroundColor = .themeBackgroundMain
            cell.backgroundConfiguration = bgrd
        }
        
        let cellReg = CellReg<WikiListCell, String> { cell, ip, item in
//            var contentConfig = cell.defaultContentConfiguration()
//            contentConfig.text = item
//            contentConfig.textProperties.font = CustomFonts.SFSemibold.font(size: .fontMainSize)
//            contentConfig.textProperties.color = .themeTextMain
//            cell.contentConfiguration = contentConfig
//            cell.accessories = []
            
            cell.text = item
            
            var bgrd = UIBackgroundConfiguration.listPlainCell()
            bgrd.backgroundColor = .themeBackgroundMain
            cell.backgroundConfiguration = bgrd
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<ListSection, ListItem>(collectionView: self.collectionView) { cv, ip, item -> UICollectionViewCell? in
            
            switch item {
            case .header(let headerText):
                let cell = cv.dequeueConfiguredReusableCell(
                    using: headerCellReg,
                    for: ip,
                    item: headerText)
                return cell
            case .answer(let answerText):
                let cell = cv.dequeueConfiguredReusableCell(
                    using: cellReg,
                    for: ip,
                    item: answerText)
                return cell
            }
            
        }
        
        var listSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        for item in viewModel.filteredItems {
            let headerListItem = ListItem.header(item.ask)
            listSnapshot.append([headerListItem])
            
            let cellListItem = ListItem.answer(item.shortAnswer)
            listSnapshot.append([cellListItem], to: headerListItem)
        }
        
        self.dataSource.apply(listSnapshot, to: ListSection.main, animatingDifferences: false)
    }
    
    func reloadList() {

        var snap = dataSource.snapshot(for: .main)
        let expandedItems = snap.items.filter { snap.isExpanded($0) }
        snap.deleteAll()

        for item in viewModel.filteredItems {
            let headerListItem = ListItem.header(item.ask)
            snap.append([headerListItem])
            
            let cellListItem = ListItem.answer(item.shortAnswer)
            snap.append([cellListItem], to: headerListItem)
        }
        snap.expand(expandedItems)
        self.dataSource.apply(snap, to: .main, animatingDifferences: true)
    }
    
}


extension WikiListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataSource.itemIdentifier(for: indexPath)!
        print("Tap on item '\(item)'")
    }
}


fileprivate enum ListSection {
    case main
}

fileprivate enum ListItem: Hashable {
    case header(String)
    case answer(String)
}
