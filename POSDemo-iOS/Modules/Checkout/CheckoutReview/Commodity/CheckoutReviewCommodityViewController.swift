//
//  CheckoutReviewCommodityViewController.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/3.
//

import UIKit
import SnapKit
import RxCocoa

public protocol CheckoutReviewCommodityViewControllerDelegate: AnyObject {
    func onNext()
}

public final class CheckoutReviewCommodityViewController: BaseViewController {
    
    public weak var delegate: CheckoutReviewCommodityViewControllerDelegate?
    private weak var commodityViewModel: CommodityViewModelType!
    
    public init(commodityViewModel: CommodityViewModelType) {
        self.commodityViewModel = commodityViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBinding()
    }
    
    private func setupBinding() {
        clearButton.rx
            .tap
            .map { _ in }
            .bind(to: commodityViewModel.inputs.onClearAllCommodity)
            .disposed(by: disposeBag)
        
        commodityViewModel.outputs
            .selectedCheckoutCommodityList
            .drive(onNext: { [weak self] list in
                self?.tableView.setData(list: list)
            })
            .disposed(by: disposeBag)
        
        commodityViewModel.outputs
            .summary
            .drive(onNext: { [weak self] summary in
                self?.countInfeView.content = summary.count.formatted
                self?.amountInfoView.content = summary.amount.formatted
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        clearButton.setTitle("清空商品", for: .normal)
        
        tableViewContainerView.backgroundColor = "bg_white".color
        snTitleLabel.setPink20(text: "貨號")
        nameTitleLabel.setPink20(text: "商品名稱")
        colorTitleLabel.setPink20(text: "顏色")
        sizeTitleLabel.setPink20(text: "尺寸")
        countTitleLabel.setPink20(text: "數量")
        priceTitleLabel.setPink20(text: "單價")
        totalTitleLabel.setPink20(text: "金額")
        tableView.viewModel = commodityViewModel
        topStackView.axis = .horizontal
        depositInfoView.content = ""
        nextButton.setTitle("選擇優惠", for: .normal)
        nextButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        view.addSubview(containerView) { make in
            make.leading.top.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(barcodeInputView) { make in
            make.leading.top.equalToSuperview()
        }
        containerView.addSubview(clearButton) { make in
            make.width.equalTo(140)
            make.height.equalTo(40)
            make.top.trailing.equalToSuperview()
        }
        
        containerView.addSubview(bottomSection) { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        bottomSection.addSubview(nextButton) { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.top.equalToSuperview().offset(26)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-26)
        }
        bottomSection.addSubview(topStackView) { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nextButton.snp.top)
        }
        topStackView.addArrangedSubview(countInfeView)
        topStackView.addArrangedSubview(amountInfoView)
        topStackView.addArrangedSubview(depositInfoView)
        
        containerView.addSubview(tableViewContainerView) { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(clearButton.snp.bottom).offset(20)
            make.bottom.equalTo(bottomSection.snp.top)
        }
        tableViewContainerView.addSubview(titleStackView) { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
        }
        snTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        nameTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        colorTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        sizeTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        countTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(135)
        }
        priceTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        for title in titleLabelList {
            titleStackView.addArrangedSubview(title)
        }
        tableViewContainerView.addSubview(tableView) { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(18)
            make.leading.equalToSuperview()
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    private let containerView = UIView()
    private let barcodeInputView = BarcodeInputView(textFieldWidth: 234, max: 13)
    private let clearButton = HollowButton()
    private let bottomSection = UIView()
    private let nextButton = SolidButton()
    
    private let topStackView = UIStackView()
    private let countInfeView = InfoView(title: "件數", spacing: 20, contentWidth: 150)
    private let amountInfoView = InfoView(title: "總計", spacing: 20, contentWidth: 150)
    private let depositInfoView = InfoView(title: "訂金", spacing: 20, contentWidth: 150)
    
    private let tableViewContainerView = UIView()
    private let titleStackView = UIStackView()
    private let snTitleLabel = UILabel()
    private let nameTitleLabel = UILabel()
    private let colorTitleLabel = UILabel()
    private let sizeTitleLabel = UILabel()
    private let countTitleLabel = UILabel()
    private let priceTitleLabel = UILabel()
    private let totalTitleLabel = UILabel()
    private var titleLabelList: [UILabel] {
        [
            snTitleLabel, nameTitleLabel, colorTitleLabel, sizeTitleLabel,
            countTitleLabel, priceTitleLabel, totalTitleLabel
        ]
    }
    private let tableView = CheckoutReviewCommodityTableView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
