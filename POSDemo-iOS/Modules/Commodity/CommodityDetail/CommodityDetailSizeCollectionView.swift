//
//  CommodityDetailSizeCollectionView.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/1/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

public final class CommodityDetailSizeCollectionView: UICollectionView {
    
    public let onSize = BehaviorRelay<CommoditySizeUiModel?>(value: nil)
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, CommoditySizeUiModel>!
    private var lastIndexPath: IndexPath?
    
    public convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 74, height: 34)
        layout.minimumLineSpacing = CGFloat(integerLiteral: 14)
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 14)
        layout.scrollDirection = .vertical
        self.init(frame: .zero, collectionViewLayout: layout)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        alwaysBounceHorizontal = false
        alwaysBounceVertical = false
        allowsSelection = true
        allowsMultipleSelection = false
        
        let cellRegistration = UICollectionView.CellRegistration<CommodityDetailSizeCollectionViewCell, CommoditySizeUiModel> { cell, _, item in
            cell.bind(item)
        }
        diffableDataSource = UICollectionViewDiffableDataSource<Int, CommoditySizeUiModel>(
            collectionView: self,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
                return cell
            }
        )
        dataSource = diffableDataSource
        delegate = self
    }
    
    public func setData(_ list: [CommoditySizeUiModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CommoditySizeUiModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        diffableDataSource.apply(snapshot, animatingDifferences: false)
        selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
    }
    
    public func clear() {
        lastIndexPath = nil
        selectItem(at: nil, animated: true, scrollPosition: .left)
    }
}

extension CommodityDetailSizeCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == lastIndexPath {
            lastIndexPath = nil
            onSize.accept(nil)
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            lastIndexPath = indexPath
            if let item = diffableDataSource.itemIdentifier(for: indexPath) {
                onSize.accept(item)
            }
        }
    }
}

public final class CommodityDetailSizeCollectionViewCell: UICollectionViewCell {
    
    override public var isSelected: Bool {
        didSet { button.isSelected = isSelected }
    }
    
    public func bind(_ item: CommoditySizeUiModel) {
        button.setTitle(item.name, for: .normal)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        button.isUserInteractionEnabled = false
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView) { make in
            make.height.equalTo(34)
            make.edges.equalToSuperview()
        }
        containerView.addSubview(button) { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let containerView = UIView()
    private let button = RadioButton(borderWidth: 1)
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
