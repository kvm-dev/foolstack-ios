//
//  TagsListVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import Foundation
import UIKit
import Combine

final class TagListVC: UIViewController {
    private var headerBar: HeaderBar!
    private var collectionView: UICollectionView!
    
    var viewModel: TagListVM!
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: TagListVM) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHeader()
        setupView()
        
        viewModel.onItemsLoaded = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func configureHeader() {
        let pres1 = self.presentedViewController != nil
        let pres2 = self.presentationController != nil
        let pres3 = self.presentingViewController != nil
        let isModal = self.navigationController == nil
        headerBar = HeaderBar(withSlider: isModal)
        view.addSubview(headerBar)
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        if isModal {
            headerBar.withSlider = true
            headerBar.color = .themeHeader
            //headerBar.titleLabel.font = CustomFonts.defaultMedium(size: .fontMainSize)
            headerBar.pinEdges(to: view.safeAreaLayoutGuide, leading: 8, trailing: -8, top: 4)
        } else {
            headerBar.color = .clear
            headerBar.titleLabel.font = CustomFonts.defaultMedium(size: 22)
            headerBar.titleLabel.textColor = .themeTextViewTitle
            headerBar.pinEdges(to: view.safeAreaLayoutGuide, leading: 8, trailing: -8, top: 37)
        }
        
        headerBar.titleLabel.text = String(localized: "Knowledge area", comment: "")
        
        let backButton: UIButton = isModal ? UIButton.customClose() : UIButton.customBack()
        backButton.tintColor = isModal ? .themeStandartIcon : .themeTextViewTitle
        headerBar.addLeftButton(button: backButton)
        backButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = self.isBeingPresented ? .themeBackgroundMain : .themeBackgroundTop
        
        let bgrdView = UIView()
        self.view.insertSubview(bgrdView, at: 0)
        bgrdView.backgroundColor = .themeBackgroundMain
        bgrdView.clipsToBounds = true
        bgrdView.layer.cornerRadius = 32
        bgrdView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bgrdView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bgrdView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            bgrdView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            bgrdView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bgrdView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        let buttonPadding: CGFloat = 40
        
        let confirmButton = BorderButton(backgroundColor: .themeAccent)
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle(String(localized: "Choice", comment: ""), for: .normal)
        confirmButton.pinEdges(to: view.safeAreaLayoutGuide, leading: buttonPadding, trailing: -buttonPadding, bottom: -buttonPadding)
        confirmButton.pinSize(height: 56)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        viewModel.$isConfirmEnabled
            .assign(to: \.isEnabled, on: confirmButton)
            .store(in: &subscriptions)

        let selectAllbutton = UIButton(type: .custom)
        view.addSubview(selectAllbutton)
        selectAllbutton.translatesAutoresizingMaskIntoConstraints = false
        selectAllbutton.setTitle(String(localized: "Select All", comment: ""), for: .normal)
        selectAllbutton.titleLabel?.font = CustomFonts.defaultRegular(size: 13)
        selectAllbutton.setTitleColor(.themeTextSecondary, for: .normal)
        NSLayoutConstraint.activate([
            selectAllbutton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            selectAllbutton.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 0),
            selectAllbutton.heightAnchor.constraint(equalToConstant: 44)
        ])
        selectAllbutton.addTarget(self, action: #selector(selectAllButtonTapped), for: .touchUpInside)
        
        let collectionViewLayout = TagsCollectionLayout()
        //        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        collectionViewLayout.minimumLineSpacing = 0
        //        collectionViewLayout.minimumInteritemSpacing = 0
        //        collectionViewLayout.scrollDirection = .vertical
        
        // CollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = nil//.clear
        //        collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        collectionView.alwaysBounceVertical = true
        
        collectionViewLayout.delegate = self
        
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: selectAllbutton.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -314)
        ])
        
        collectionView?.register(TagListCell.self, forCellWithReuseIdentifier: TagListCell.reuseIdentifier)
        
    }
    
    @objc func closePressed(_ sender: UIButton) {
        let pres1 = self.presentedViewController != nil
        let pres2 = self.presentationController != nil
        let pres3 = self.presentingViewController != nil
        let isModal = self.isBeingPresented
        if self.navigationController == nil {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func confirmButtonTapped() {
        viewModel.confirm()
    }
    
    @objc func selectAllButtonTapped() {
        viewModel.selectAll()
        collectionView.reloadData()
    }
}


extension TagListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = viewModel.toggleItemAt(index: indexPath.row)
        let cell = collectionView.cellForItem(at: indexPath) as! TagListCell
        cell.setSelected(selected)
    }
}

// MARK: CollectionView DataSource

extension TagListVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      viewModel.items.count
  }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let item = viewModel.items[indexPath.row]
      let selected = viewModel.isItemSelectedAt(index: indexPath.row)
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListCell.reuseIdentifier, for: indexPath) as! TagListCell
      cell.configure(title: item.name)
      cell.setSelected(selected)
      return cell
  }
}

@MainActor
extension TagListVC: TagsCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let item = viewModel.items[indexPath.row]
        let width = item.name.width(withConstrainedHeight: 20, font: CustomFonts.defaultBold(size: .fontMainSize))
        return CGSize(width: width + 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, insetsForItemsInSection section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemSpacingInSection section: Int) -> CGFloat {
        12
    }
    
    
}




