//
//  CatSpecView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 02.01.2024.
//

import Foundation
import UIKit

@MainActor
final class CatSpecView : UIView {
    
    var presenter: CatListPresenter!
    
    var collectionView: UICollectionView!
    
    var items: [CatEntity] = []
    
    init(presenter: CatListPresenter) {
        super.init(frame: .zero)
        self.presenter = presenter
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(items: [CatEntity]) {
        print("Show Spec List")
        self.items = items
        self.collectionView.reloadData()
    }
    
    private func initialize() {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.scrollDirection = .vertical
        
        // CollectionView
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
        //collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        //collectionView.bounces = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = nil//.clear
        collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        collectionView.isScrollEnabled = true
        collectionView.isUserInteractionEnabled = true
        
        self.addSubview(collectionView)
        
        //        if #available(iOS 11.0, *) {
        //          collectionView.contentInsetAdjustmentBehavior = .never
        //        }
        //
        //        if #available(iOS 10.0, *) {
        //          collectionView.isPrefetchingEnabled = true
        //        }
        
        collectionView.pinEdges(to: self)
        
        // Register cell classes
        collectionView?.register(CatSpecCell.self, forCellWithReuseIdentifier: CatSpecCell.reuseIdentifier)
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension CatSpecView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPadding: CGFloat = 20 + 52
        let termData = self.items[indexPath.row]
        let text = termData.name
        //let existInDict = termData.isExistInDictionary
        let textWidth = collectionView.frame.width - cellPadding * 2
        let textHeight = text.height(withConstrainedWidth: textWidth, font: CustomFonts.defaultSemiBold(size: 16)) + 28// + 38
        let h = max(textHeight, 52)
        //print("Item height \(h), textWidth \(textWidth), textHeight \(textHeight), text '\(text)', bounds width \(collectionView.bounds.width)")
        
        //    let number = indexPath.section == 0 ? indexPath.row : indexPath.row + viewModel.items[0].count
        //    let w: CGFloat = cellSizes[number]
        return CGSize(width: collectionView.bounds.width, height: h)
    }
}

// MARK: CollectionView DataSource

extension CatSpecView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatSpecCell.reuseIdentifier, for: indexPath) as! CatSpecCell
        cell.configure(title: item.name, imagePath: item.image, index: indexPath.row)
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension CatSpecView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let ent = items[indexPath.row]
      let selected = presenter.selectEntity(entity: ent)
      let cell = collectionView.cellForItem(at: indexPath) as! CatSpecCell
      cell.setToggled(selected)
  }
  
}
