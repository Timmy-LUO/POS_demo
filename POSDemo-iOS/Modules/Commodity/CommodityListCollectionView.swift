//
//  CommodityListCollectionView.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/1/27.
//

import UIKit
import SnapKit

public protocol CommodityListCollectionViewDelegate: AnyObject {
    func commodityListCollectView(_ collectionView: CommodityListCollectionView, onSelected: CommodityUiModel)
}

public final class CommodityListCollectionView: UICollectionView {
    
    public weak var commodityListCollectionViewDelegate: CommodityListCollectionViewDelegate?
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, CommodityUiModel>!
    
    public convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = CGFloat(integerLiteral: 20)
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 40)
        layout.scrollDirection = .vertical
        self.init(frame: .zero, collectionViewLayout: layout)
        contentInset = UIEdgeInsets(top: 15, left: 40, bottom: 15, right: 40)
        backgroundColor = "bg_white".color
        layer.cornerRadius = 2
        alwaysBounceHorizontal = false
        alwaysBounceVertical = false
        
        let cellRegistration = UICollectionView.CellRegistration<CommodityListCollectionViewCell, CommodityUiModel> { cell, _, item in
            cell.bind(item)
        }
        diffableDataSource =  UICollectionViewDiffableDataSource<Int, CommodityUiModel>(
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
    
    public func setData(_ list: [CommodityUiModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CommodityUiModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CommodityListCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var size: CGSize = .zero
        size.width = (collectionView.bounds.width - 120) / 2
        size.height = 105
        return size
    }
}

extension CommodityListCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = diffableDataSource.itemIdentifier(for: indexPath) {
            commodityListCollectionViewDelegate?.commodityListCollectView(self, onSelected: item)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

public final class CommodityListCollectionViewCell: UICollectionViewCell {
    
    public func bind(_ commodity: CommodityUiModel) {
        snLabel.text = commodity.sn
        nameLabel.text = commodity.name
        imageView.image = "ic_logo".image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        snTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        snTitleLabel.text = "貨號"
        snTitleLabel.font = .systemFont(ofSize: 18)
        snTitleLabel.textColor = "text_grey_light".color
        snLabel.font = .systemFont(ofSize: 18)
        snLabel.textColor = "text_brown".color
        nameTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nameTitleLabel.text = "名稱"
        nameTitleLabel.font = .systemFont(ofSize: 18)
        nameTitleLabel.textColor = "text_grey_light".color
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.font = .systemFont(ofSize: 18)
        nameLabel.textColor = "text_brown".color
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView) { make in
            make.width.height.equalTo(105)
            make.leading.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(textContentView) { make in
            make.leading.equalTo(imageView.snp.trailing).offset(25)
            make.top.bottom.equalTo(imageView)
            make.trailing.equalToSuperview()
        }
        
        textContentView.addSubview(snTitleLabel) { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(14)
        }
        
        textContentView.addSubview(snLabel) { make in
            make.leading.equalTo(snTitleLabel.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(14)
            make.trailing.equalToSuperview()
        }
        
        textContentView.addSubview(nameTitleLabel) { make in
            make.leading.equalToSuperview()
            make.top.equalTo(snLabel.snp.bottom).offset(14)
        }
        
        textContentView.addSubview(nameLabel) { make in
            make.leading.equalTo(nameTitleLabel.snp.trailing).offset(10)
            make.top.equalTo(snLabel.snp.bottom).offset(14)
            make.trailing.equalToSuperview()
        }
    }
    
    private let imageView = UIImageView()
    private let textContentView = UIView()
    private let snTitleLabel = UILabel()
    private let snLabel = UILabel()
    private let nameTitleLabel = UILabel()
    private let nameLabel = UILabel()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
