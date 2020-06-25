//
//  SwipingActionViewController.swift
//  CompTesting
//
//  Created by Ravi Bastola on 6/24/20.
//

import UIKit

struct Item: Identifiable, Hashable {
    let id = UUID()
    
    let name: String
    let profession: String
    
}

class SwipingActionViewController: UICollectionViewController {
    
    
    enum Section {
        case main
    }
    
    
    var items: [Item] = [
        Item(name: "Sabin", profession: "Developer"),
        Item(name: "Shyam", profession: "Developer"),
        Item(name: "Ravi", profession: "Developer"),
        Item(name: "Denny", profession: "Developer"),
    ]
    
    var dataSource: UICollectionViewDiffableDataSource<Section,Item>!
    
    init() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemBackground
        collectionView.backgroundColor = .systemBackground
        
        collectionView.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        configureDataSource()
    }
    
    func configureDataSource() {
        
        let cellConfiguration = UICollectionView.CellRegistration<UICollectionViewListCell,Item>.init { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            
            
            var action: [UIContextualAction] = [UIContextualAction]()
            
            let leadingSwipeAction = UIContextualAction(style: .normal, title: "Mark Favorite") { (_, _, completion) in
                print(item.id)
                completion(true)
            }
            
            let secondLeadingSwipe = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
                print(item.id)
                completion(true)
            }
            
            
            action.append(leadingSwipeAction)
            
            action.append(secondLeadingSwipe)
            
          
            
            cell.leadingSwipeActionsConfiguration = UISwipeActionsConfiguration(actions: action)
            
            cell.accessories = [
                .delete(),
                .disclosureIndicator()
            ]
            
            cell.contentConfiguration = content
        }
        
        
        dataSource = .init(collectionView: collectionView, cellProvider: { (cv, indexPath, item) -> UICollectionViewCell? in
            
            let cell = cv.dequeueConfiguredReusableCell(using: cellConfiguration, for: indexPath, item: item)
            
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot)
        
        
    }
    
    
}
