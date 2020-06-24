//
//  ListSectionHeader.swift
//  CompTesting
//
//  Created by Ravi Bastola on 6/24/20.
//

import UIKit

class ListSectionHeaderViewController: UIViewController {
    
    fileprivate lazy var itemCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate =  self
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
                
                // MARK:- For hierarchical DS's Use first item in section which will work as expanding or doing similar
                
                configuration  = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                configuration.headerMode = .supplementary
            default:
                configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
                configuration.headerMode = .none
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
                content.image = UIImage(systemName: "envelope")
                
            default:
                content.image = UIImage(systemName: "trash.fill")
                content.text = "Bye world"
            }
            
            cell.contentConfiguration = content
            
        }
        
        let headerRegistrations = UICollectionView.SupplementaryRegistration<SectionHeader>.init(elementKind: UICollectionView.elementKindSectionHeader) { (headerView, reuseIdentifier, indexPath) in
            
            let section = LayoutSections(rawValue: indexPath.section)
            
            if section == .main {
                headerView.backgroundColor = .red
            }
        }
        
        
        dataSource = .init(collectionView: itemCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            
            return cell
        })
        
        dataSource.supplementaryViewProvider  = .some({ (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let view =  collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistrations, for: indexPath)
            
            return view
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


class SectionHeader: UICollectionReusableView  {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


extension ListSectionHeaderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        
        print(item!)
    }
}
