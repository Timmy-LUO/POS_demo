//
//  CommodityLabelTableView.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/1/22.
//

import UIKit
import SnapKit

public final class CommodityLabelTableView: UITableView {
    
    public weak var viewModel: CommodityViewModelInputs!
    private var diffableDataSource: UITableViewDiffableDataSource<Int, String>!
    
    public convenience init() {
        self.init(frame: .zero, style: .plain)
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        separatorStyle = .none
        alwaysBounceHorizontal = false
        alwaysBounceVertical = false
        backgroundColor = nil
        register(CommodityLabelTableViewCell.self, forCellReuseIdentifier: CommodityLabelTableViewCell.identifier)
        diffableDataSource = UITableViewDiffableDataSource<Int, String>(tableView: self) { tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: CommodityLabelTableViewCell.identifier) as! CommodityLabelTableViewCell
            cell.bind(item)
            return cell
        }
        dataSource = diffableDataSource
        delegate = self
    }
    
    public func setData(_ list: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
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

extension CommodityLabelTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = diffableDataSource.itemIdentifier(for: indexPath) {
            viewModel.commodityLabel.accept(item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

public final class CommodityLabelTableViewCell: UITableViewCell {
    
    public static let identifier = "CommodityLabelTableViewCell"
    
    public func bind(_ item: String) {
        titleLabel.text = item
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        titleLabel.setBrown18()
        titleLabel.numberOfLines = 0
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView) { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        containerView.addSubview(titleLabel) { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
