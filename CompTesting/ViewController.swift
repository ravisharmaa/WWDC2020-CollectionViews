//
//  ViewController.swift
//  CompTesting
//
//  Created by Ravi Bastola on 6/24/20.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate lazy var itemCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(itemCollectionView)
        
        NSLayoutConstraint.activate([
            itemCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            itemCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        configureDataSource()
    }
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int>.init { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = "Helo world"
            cell.contentConfiguration = content
        }
        
        dataSource = .init(collectionView: itemCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell =  collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section,Int>()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(Array(0..<94))
        
        dataSource.apply(snapshot)
    }


}

