//
//  CheckoutReviewCommodityTableView.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/3.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class CheckoutReviewCommodityTableView: UITableView {
    
    public weak var viewModel: CommodityViewModelType!
    private var diffableDataSource: UITableViewDiffableDataSource<Int, CheckoutCommodityUiModel>!
    
    public convenience init() {
        self.init(frame: .zero, style: .grouped)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        separatorStyle = .none
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = false
        allowsSelection = false
        backgroundColor = nil
        register(CheckoutReviewCommodityTableViewCell.self, forCellReuseIdentifier: CheckoutReviewCommodityTableViewCell.identifier)
        diffableDataSource = UITableViewDiffableDataSource<Int, CheckoutCommodityUiModel>(tableView: self) { [weak self] tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutReviewCommodityTableViewCell.identifier) as! CheckoutReviewCommodityTableViewCell
            cell.viewModel = self?.viewModel
            cell.bind(item)
            return cell
        }
        dataSource = diffableDataSource
    }
    
    public func setData(list: [CheckoutCommodityUiModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CheckoutCommodityUiModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(list, toSection: 0)
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public final class CheckoutReviewCommodityTableViewCell: UITableViewCell {
    
    public static let identifier = "CheckoutReviewCommodityTableViewCell"
    
    public weak var viewModel: CommodityViewModelType!
    private var bag = DisposeBag()
    
    public func bind(_ item: CheckoutCommodityUiModel) {
        snLabel.text = item.sn
        nameLabel.text = item.name
        colorLabel.text = item.color?.name ?? ""
        sizeLabel.text = item.size?.name ?? ""
        countLabel.text = "\(item.count)"
        priceLabel.text = item.price.formatted
        amountLabel.text = item.amount.formatted
        
        plusButton.rx
            .tap
            .map { _ in item }
            .bind(to: viewModel.inputs.onIncrementCommodity)
            .disposed(by: bag)
        
        minusButton.rx
            .tap
            .map { _ in item }
            .bind(to: viewModel.inputs.onDecreaseCommodity)
            .disposed(by: bag)
        
        clearButton.rx
            .tap
            .map { _ in item }
            .bind(to: viewModel.inputs.onClearCommodity)
            .disposed(by: bag)
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        snLabel.setBlack20()
        snLabel.verticalAlignment = .top
        snLabel.numberOfLines = 5
        
        nameLabel.setBlack20()
        nameLabel.verticalAlignment = .top
        nameLabel.numberOfLines = 5
        
        colorLabel.setBlack20()
        colorLabel.autoFontSize()
        
        sizeLabel.setBlack20()
        sizeLabel.autoFontSize()
        
        countLabel.setBlack20()
        countLabel.autoFontSize()
        
        plusButton.setImage("ic_checkout_review_commodity_plus".image, for: .normal)
        minusButton.setImage("ic_checkout_review_commodity_minus".image, for: .normal)
        clearButton.setImage("ic_checkout_review_commodity_delete".image, for: .normal)
        
        priceLabel.setBlack20()
        priceLabel.autoFontSize()
        
        amountLabel.setBlack20()
        amountLabel.autoFontSize()
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView) { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-28)
        }
        containerView.addSubview(snLabel) { make in
            make.width.equalTo(100)
            make.leading.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
        }
        containerView.addSubview(nameLabel) { make in
            make.width.equalTo(200)
            make.leading.equalTo(snLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        containerView.addSubview(colorLabel) { make in
            make.width.equalTo(80)
            make.leading.equalTo(nameLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        containerView.addSubview(sizeLabel) { make in
            make.width.equalTo(70)
            make.leading.equalTo(colorLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        containerView.addSubview(countLabel) { make in
            make.width.equalTo(40)
            make.leading.equalTo(sizeLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        containerView.addSubview(minusButton) { make in
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.leading.equalTo(countLabel.snp.trailing).offset(10)
            make.top.equalToSuperview()
        }
        containerView.addSubview(plusButton) { make in
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.leading.equalTo(minusButton.snp.trailing).offset(20)
            make.top.equalToSuperview()
        }
        containerView.addSubview(priceLabel) { make in
            make.width.equalTo(80)
            make.leading.equalTo(plusButton.snp.trailing).offset(20)
            make.top.bottom.equalToSuperview()
        }
        containerView.addSubview(amountLabel) { make in
            make.width.equalTo(70)
            make.leading.equalTo(priceLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        containerView.addSubview(clearButtonContainerView) { make in
            make.leading.equalTo(amountLabel.snp.trailing)
            make.top.trailing.equalToSuperview()
        }
        clearButtonContainerView.addSubview(clearButton) { make in
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    private let containerView = UIView()
    private let snLabel = VerticalAlignLabel()
    private let nameLabel = VerticalAlignLabel()
    private let colorLabel = VerticalAlignLabel()
    private let sizeLabel = VerticalAlignLabel()
    private let countLabel = VerticalAlignLabel()
    private let plusButton = UIButton()
    private let minusButton = UIButton()
    private let priceLabel = VerticalAlignLabel()
    private let amountLabel = VerticalAlignLabel()
    private let clearButtonContainerView = UIView()
    private let clearButton = UIButton()
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

