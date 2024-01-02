//
//  CatSpecListVC.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 29.12.2023.
//

import Foundation
import UIKit

@MainActor
final class CatSpecListVC : UIViewController, CatListView {
    
    var presenter: CatListPresenter!
    
    var headerBar: HeaderBar!
    var contentView: UIView!
    var bottomView: UIView!
    var collectionView: UICollectionView!
    
    var items: [CatEntity] = []
    
    //    init(presenter: WikiListPresenter) {
    //        self.presenter = presenter
    //
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createView()
        //        self.navigationController?.isNavigationBarHidden = true
        
        presenter.viewDidLoad(view: self)
    }
    
    func show(items: [CatEntity]) {
        print("Show Prof List")
        self.items = items
        self.collectionView.reloadData()
    }
    
    private func createView() {
        self.view.backgroundColor = .themeBackgroundTop
        
        let v = UIView()
        self.contentView = v
        self.view.addSubview(v)
        v.backgroundColor = .themeBackgroundMain
        v.clipsToBounds = true
        v.layer.cornerRadius = 32
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            v.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            v.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        createHeader()
        
        bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        let mainImage = UIImageView()
        self.view.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.contentMode = .center
        mainImage.image = UIImage(named: "prof_main")
        
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: self.headerBar.bottomAnchor, constant: 30),
            mainImage.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -30),
            mainImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mainImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        ])
        
        createScrolledContent()
    }
    
    private func createHeader() {
        headerBar = HeaderBar(withSlider: false)
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerBar)
        headerBar.color = .clear
        //headerBar.headerView.backgroundColor = .themeBackgroundMain
        //headerBar.pinEdges(to: view, leading: 8, trailing: -8, top: 0)
        headerBar.titleLabel.text = NSLocalizedString("Choice profession", comment: "")
        
        NSLayoutConstraint.activate([
            headerBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            headerBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            headerBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22)
        ])
        
//        let closeButton = UIButton.customBack()
//        headerBar.addLeftButton(button: closeButton)
        //closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        
    }
    
    private func createScrolledContent() {
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

        bottomView.addSubview(collectionView)
        
//        if #available(iOS 11.0, *) {
//          collectionView.contentInsetAdjustmentBehavior = .never
//        }
//        
//        if #available(iOS 10.0, *) {
//          collectionView.isPrefetchingEnabled = true
//        }
        
        collectionView.pinEdges(to: bottomView)
        
        // Register cell classes
        collectionView?.register(CatSpecCell.self, forCellWithReuseIdentifier: CatSpecCell.reuseIdentifier)

    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension CatSpecListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let cellPadding: CGFloat = 12 + 52
      let termData = self.items[indexPath.row]
        let text = termData.name
      //let existInDict = termData.isExistInDictionary
        let textWidth = collectionView.frame.width - cellPadding * 2
        let textHeight = text.height(withConstrainedWidth: textWidth, font: CustomFonts.defaultSemiBold(size: 16)) + cellPadding*2// + 38
      //let w = max(100, min(fullWidth, collectionView.bounds.width))
      let h = min(textHeight, 52)
      //print("Item width \(w), fullWidth \(fullWidth), bounds width \(collectionView.bounds.width)")

  //    let number = indexPath.section == 0 ? indexPath.row : indexPath.row + viewModel.items[0].count
  //    let w: CGFloat = cellSizes[number]
      return CGSize(width: collectionView.bounds.width, height: h)
    }
}

// MARK: CollectionView DataSource

extension CatSpecListVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let item = items[indexPath.row]
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatSpecCell.reuseIdentifier, for: indexPath) as! CatSpecCell
      cell.configure(title: item.name, imagePath: item.image, index: indexPath.row)
      cell.onAction = { [weak self] index in
          return true
      }
      return cell
  }
}




