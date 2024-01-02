//
//  CatProfView.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 02.01.2024.
//

import Foundation
import UIKit

@MainActor
final class CatProfView : UIView {
    
    var presenter: CatListPresenter!
    
    var collectionView: UICollectionView!
    
    var items: [CatEntity] = []
    var onAction: ((CatEntity) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(items: [CatEntity]) {
        print("Show Prof List")
        self.items = items
        self.collectionView.reloadData()
    }
    
    private func initialize() {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal
        
        // CollectionView
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
        //collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        //collectionView.bounces = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = nil//.clear
        collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        collectionView.isScrollEnabled = true
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceHorizontal = true

        self.addSubview(collectionView)
        
        if #available(iOS 11.0, *) {
          collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        if #available(iOS 10.0, *) {
          collectionView.isPrefetchingEnabled = true
        }
        
        collectionView.pinEdges(to: self)
        
        // Register cell classes
        collectionView?.register(CatProfCell.self, forCellWithReuseIdentifier: CatProfCell.reuseIdentifier)

    }
}


extension CatProfView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        //print("CardView size \(size)")
        return size
    }
}

// MARK: CollectionView DataSource

extension CatProfView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let item = items[indexPath.row]
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatProfCell.reuseIdentifier, for: indexPath) as! CatProfCell
      cell.configure(title: item.name, description: "Description kjsdhfk skdjfh ksjdhf hsdkjf hskdfhkshfkjwehf fdjfhks", imagePath: item.image, index: indexPath.row)
      cell.onAction = { [weak self] index in
          guard let self = self else {return}
          let selectedItem = items[index]
          self.onAction?(selectedItem)
      }
      return cell
  }
}


