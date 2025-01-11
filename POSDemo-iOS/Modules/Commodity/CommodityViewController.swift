//
//  CommodityViewController.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2024/11/14.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxGesture

public final class CommodityViewController: BaseViewController {
    
    private weak var parentCoordinator: WelcomeCoordinator!
    private let viewModel: CommodityViewModelType!
    
    public init(
        _ parentCoordinator: WelcomeCoordinator,
        viewModel: CommodityViewModelType
    ) {
        self.parentCoordinator = parentCoordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBinding()
    }
    
    private func setupBinding() {
        searchInputView
            .contentRelay
            .bind(to: viewModel.inputs.commodityFilter)
            .disposed(by: disposeBag)
        
        titleLabel.rx
            .tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.inputs.toRootCommodityLabel)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .commodityLabelList
            .drive(onNext: { [weak self] list in
                self?.labelTableView.setData(list)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .commodity
            .drive(onNext: { [weak self] commodityList in
                self?.labelCountLabel.text = "共 \(commodityList.count) 件商品"
                self?.commodityCollectionView.setData(commodityList)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func checkout() {
        parentCoordinator.toCheckoutReview(
            parentCoordinator: parentCoordinator,
            isFirst: false,
            commodityViewModel: viewModel
        )
    }
    
    private func setupUI() {
        logoImageView.image = "ic_logo".image
        logoImageView.layer.cornerRadius = 8
        logoImageView.layer.masksToBounds = true
        
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 20
        
        titleLabel.setPink20(text: "全部商品")
        titleLabel.textAlignment = .center
        
        labelTableView.viewModel = viewModel.inputs
        
        separatorView.backgroundColor = "separator_grey".color
        
        checkoutButton.setTitle("結帳", for: .normal)
        checkoutButton.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        
        labelCountLabel.setBlackLight18(text: "共 0 件商品")
        
        commodityCollectionView.commodityListCollectionViewDelegate = self
    }
    
    private func setupLayout() {
        safeEdgesView.addSubview(leftSectionView) { make in
            make.width.equalTo(256)
            make.leading.top.bottom.equalToSuperview()
        }
        
        leftSectionView.addSubview(logoImageView) { make in
            make.height.equalTo(180)
            make.leading.equalToSuperview().offset(22)
            make.top.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-22)
        }
        
        leftSectionView.addSubview(buttonsStackView){ make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
        }
        buttonsStackView.addArrangedSubview(titleLabel)
        
        leftSectionView.addSubview(labelTableView) { make in
            make.leading.equalToSuperview().offset(22)
            make.top.equalTo(buttonsStackView.snp.bottom).offset(28)
            make.trailing.equalToSuperview().offset(-22)
            make.bottom.equalToSuperview()
        }
        
        safeEdgesView.addSubview(separatorView) { make in
            make.width.equalTo(1)
            make.leading.equalTo(leftSectionView.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        
        safeEdgesView.addSubview(searchInputView) { make in
            make.width.equalTo(234)
            make.height.equalTo(38)
            make.leading.equalTo(separatorView.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        safeEdgesView.addSubview(checkoutButton) { make in
            make.width.equalTo(140)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
        }
        
        safeEdgesView.addSubview(labelCountLabel) { make in
            make.leading.equalTo(separatorView.snp.trailing).offset(20)
            make.top.equalTo(searchInputView.snp.bottom).offset(40)
        }
        
        safeEdgesView.addSubview(commodityCollectionView) { make in
            make.leading.equalTo(separatorView.snp.trailing).offset(20)
            make.top.equalTo(labelCountLabel.snp.bottom).offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-18)
        }
    }
    
    private let leftSectionView = UIView()
    private let logoImageView = UIImageView()
    private let buttonsStackView = UIStackView()
    private let titleLabel = UILabel()
    private let labelTableView = CommodityLabelTableView()
    private let separatorView = UIView()
    private let searchInputView = SearchInputView()
    private let checkoutButton = SolidButton()
    private let labelCountLabel = UILabel()
    private let commodityCollectionView = CommodityListCollectionView()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}

extension CommodityViewController: CommodityListCollectionViewDelegate {
    public func commodityListCollectView(_ collectionView: CommodityListCollectionView, onSelected: CommodityUiModel) {
        let vc = CommodityDetailViewController(commodity: onSelected, viewModel: viewModel)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
