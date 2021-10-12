//
//  ViewController.swift
//  CellManagementPractice
//
//  Created by 坂本龍哉 on 2021/10/12.
//

import UIKit

struct SettingCellData: Hashable {
    let title: String
    let identifier = UUID()
}
struct SwitchCellData: Hashable {
    let title: String
    let isOn: Bool
    let identifier = UUID()
}

enum Item: Hashable {
    case setting(SettingCellData)
    case switching(SwitchCellData)
}

final class ViewController: UIViewController {
    
    private enum Secion: CaseIterable {
        case setting
        case application
        var items: [Item] {
            switch self {
            case .setting:
                return SettingItem.allCases.map { $0.item }
            case .application:
                return ApplicationItem.allCases.map { $0.item }
            }
        }
    }
    private enum SettingItem: CaseIterable {
        case color
        case notification
        var item: Item {
            switch self {
            case .color:
                return .setting(SettingCellData(title: "テーマカラー"))
            case .notification:
                return .switching(SwitchCellData(title: "通知", isOn: true))
            }
        }
    }
    private enum ApplicationItem: CaseIterable {
        case share
        case operation
        case evaluate
        var item: Item {
            switch self {
            case .share:
                return .setting(SettingCellData(title: "このアプリをシェアする"))
            case .operation:
                return .setting(SettingCellData(title: "操作方法"))
            case .evaluate:
                return .setting(SettingCellData(title: "評価する"))
            }
        }
    }

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Secion, Item>! = nil
    private var cells: [SettingCellData] = []
    
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
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, item in
            cell.accessories = [.disclosureIndicator()]
            var contetnt = cell.defaultContentConfiguration()
            switch item {
            case .setting(let data): contetnt.text = data.title
            case .switching(let data): contetnt.text = data.title
            }
            cell.contentConfiguration = contetnt
        }
        
        dataSource = UICollectionViewDiffableDataSource<Secion, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Secion, Item>()
        Secion.allCases.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.items, toSection: $0)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

// SwitchCellDataなどにhashable適合せず、Itemに対して適合させる時
//extension Item {
//    static func == (lhs: Item, rhs: Item) -> Bool {
//        switch (lhs, rhs) {
//        case (.setting(let leftData), .setting(let rightData)):
//            return leftData.title == rightData.title
//        case (.switching(let leftdata), .switching(let rightdata)):
//            return leftdata.title == rightdata.title
//        default: return false
//        }
//    }
//    func hash(into hasher: inout Hasher) {
//        switch self {
//        case .setting:
//            hasher.combine("setting")
//        case .switching:
//            hasher.combine("switching")
//        }
//    }
//}
