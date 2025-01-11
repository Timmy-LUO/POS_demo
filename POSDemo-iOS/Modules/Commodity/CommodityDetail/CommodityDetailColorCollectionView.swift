//
//  CommodityDetailColorCollectionView.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/2/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

public final class CommodityDetailColorCollectionView: UICollectionView {
    
    public let onColor = BehaviorRelay<CommodityColorUiModel?>(value: nil)
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, CommodityColorUiModel>!
    private var lastIndexPath: IndexPath?
    
    public convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = CGFloat(integerLiteral: 14)
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 14)
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.init(frame: .zero, collectionViewLayout: layout)
        contentInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        alwaysBounceVertical = false
        showsHorizontalScrollIndicator = false
        allowsSelection = true
        allowsMultipleSelection = false
        
        let cellRegistration = UICollectionView.CellRegistration<CommodityDetailColorCollectionViewCell, CommodityColorUiModel> { cell, _, item in
            cell.bind(item)
        }
        diffableDataSource =  UICollectionViewDiffableDataSource<Int, CommodityColorUiModel>(
            collectionView: self,
            cellProvider: { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
        dataSource = diffableDataSource
        delegate = self
    }
    
    public func setData(_ list: [CommodityColorUiModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CommodityColorUiModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        diffableDataSource.apply(snapshot, animatingDifferences: false)
        selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
    }
}

extension CommodityDetailColorCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if let item = diffableDataSource.itemIdentifier(for: indexPath) {
            let size = item.name.size(withAttributes: nil)
            return CGSize(width: (size.width + 40), height: 36)
        } else {
            return .zero
        }
    }
}

extension CommodityDetailColorCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == lastIndexPath {
            lastIndexPath = nil
            onColor.accept(nil)
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            lastIndexPath = indexPath
            if let item = diffableDataSource.itemIdentifier(for: indexPath) {
                onColor.accept(item)
            }
        }
    }
}

public final class CommodityDetailColorCollectionViewCell: UICollectionViewCell {
    
    override public var isSelected: Bool {
        didSet { button.isSelected = isSelected }
    }
    
    public func bind(_ item: CommodityColorUiModel) {
        button.setTitle(item.name, for: .normal)
        let width = item.name.size(withAttributes: nil).width + 40
        containerView.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
        button.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
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
            make.width.equalTo(0)
            make.height.equalTo(36)
            make.edges.equalToSuperview()
        }
        containerView.addSubview(button) { make in
            make.width.equalTo(0)
            make.edges.equalToSuperview()
        }
    }
    
    private let containerView = UIView()
    private let button = RadioButton(borderWidth: 1)
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
