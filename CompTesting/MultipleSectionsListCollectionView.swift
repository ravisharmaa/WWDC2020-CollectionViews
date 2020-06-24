//
//  MultipleSectionsListCollectionView.swift
//  CompTesting
//
//  Created by Ravi Bastola on 6/24/20.
//

import UIKit

class MultipleSectionListCollectionView: UIViewController {
    
    fileprivate lazy var itemCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()

    enum LayoutSections: Int, CaseIterable {
        case main
        case secondary
    }
    
    var dataSource: UICollectionViewDiffableDataSource<LayoutSections, Int>!
    
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
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout.init(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let section = LayoutSections(rawValue: sectionIndex)
            
            var configuration: UICollectionLayoutListConfiguration!
            
            switch section {
            case .main:
                configuration  = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            default:
                configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
                
            }
            
            let collectionSection = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            
            
            return collectionSection
            
            
        })
        
        return layout
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int>.init { (cell, indexPath, item) in
           
            let section = LayoutSections(rawValue: indexPath.section)
            
            var content = cell.defaultContentConfiguration()
            
            switch section {
            case .main:
                content.text = "Hello world"
            default:
                content.text = "Bye world"
            }
            
            cell.contentConfiguration = content
        }
        
        
        dataSource = .init(collectionView: itemCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            
            return cell
        })
        
        
        var snapshot = NSDiffableDataSourceSnapshot<LayoutSections,Int>()
        
        LayoutSections.allCases.forEach { (section) in
            snapshot.appendSections([section])
            
            if section == .main {
                snapshot.appendItems(Array(0..<5))
            } else {
                snapshot.appendItems(Array(5..<10))
            }
        }
        
        dataSource.apply(snapshot)
        
        
    }
    
    
}
