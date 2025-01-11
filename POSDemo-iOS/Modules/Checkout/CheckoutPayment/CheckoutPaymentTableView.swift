//
//  CheckoutPaymentTableView.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/9.
//

import UIKit

public final class CheckoutPaymentTableView: UITableView {
    
    private var diffableDataSource: UITableViewDiffableDataSource<Int, CheckoutPaymentItemUiModel>!
    
    public convenience init() {
        self.init(frame: .zero, style: .plain)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        separatorStyle = .none
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = false
        allowsSelection = false
        backgroundColor = nil
        register(CheckoutPaymentTableViewCell.self, forCellReuseIdentifier: CheckoutPaymentTableViewCell.identifier)
        diffableDataSource = UITableViewDiffableDataSource<Int, CheckoutPaymentItemUiModel>(tableView: self) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutPaymentTableViewCell.identifier) as! CheckoutPaymentTableViewCell
            cell.bind(item)
            return cell
        }
        dataSource = diffableDataSource
    }
    
    public func setData(_ list: [CheckoutPaymentItemUiModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CheckoutPaymentItemUiModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public final class CheckoutPaymentTableViewCell: UITableViewCell {
    
    public static let identifier = "CheckoutPaymentTableViewCell"
    
    public func bind(_ item: CheckoutPaymentItemUiModel) {
        titleLabel.text = item.title
        contentLabel.text = item.content
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        titleLabel.textColor = "text_black_light".color
        titleLabel.font = .systemFont(ofSize: 20)
        contentLabel.textColor = "text_black_light".color
        contentLabel.font = .systemFont(ofSize: 20)
        contentLabel.numberOfLines = 50
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView) { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
        containerView.addSubview(titleLabel) { make in
            make.width.equalTo(134)
            make.leading.top.equalToSuperview()
        }
        containerView.addSubview(contentLabel) { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let contentLabel = VerticalAlignLabel()
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
