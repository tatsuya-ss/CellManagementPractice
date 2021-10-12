//
//  ViewController.swift
//  CellManagementPractice
//
//  Created by 坂本龍哉 on 2021/10/12.
//

import UIKit

final class ViewController: UIViewController {
    
    private enum Secion: String, CaseIterable {
        case setting
        case application
    }
    private enum Item: String, CaseIterable {
        case setting
    }

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Secion, String>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        print(#function)
    }

}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }

    private func configureHierarchy() {
        collectionView.collectionViewLayout = createListLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, item in
            cell.accessories = [.disclosureIndicator()]
            var contetnt = cell.defaultContentConfiguration()
            contetnt.text = item
            cell.contentConfiguration = contetnt
        }
        
        dataSource = UICollectionViewDiffableDataSource<Secion, String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Secion, String>()
        Secion.allCases.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems([$0.rawValue], toSection: $0)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}
