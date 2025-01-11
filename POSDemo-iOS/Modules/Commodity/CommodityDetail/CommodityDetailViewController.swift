//
//  CommodityDetailViewController.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2024/12/9.
//

import UIKit
import SnapKit
import RxGesture
import RxSwiftExt

public final class CommodityDetailViewController: BaseViewController {
    
    private weak var viewModel: CommodityViewModelType!
    private let commodity: CommodityUiModel!
    
    public init(
        commodity: CommodityUiModel,
        viewModel: CommodityViewModelType
    ) {
        self.commodity = commodity
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
        viewModel.inputs.onSelectedSize.accept(commodity.sizeList.first)
        viewModel.inputs.onSelectedColor.accept(commodity.colorList.first)
        
        closeImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        colorCollectionView.onColor
            .unwrap()
            .bind(to: viewModel.inputs.onSelectedColor)
            .disposed(by: disposeBag)
        
        sizeCollectionView.onSize
            .unwrap()
            .bind(to: viewModel.inputs.onSelectedSize)
            .disposed(by: disposeBag)
        
        addButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.inputs.onConfirmedCommodity.accept(self.commodity!)
                dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        closeImageView.image = "ic_close".image
        imageView.image = "ic_logo".image
        snTitleLabel.setPink18(text: "貨號")
        snLabel.setBlack18(text: commodity.sn)
        
        nameTitleLabel.setPink18(text: "名稱")
        nameLabel.setBlack18(text: commodity.name)
        
        colorTitleLabel.setPink18(text: "顏色")
        colorCollectionView.setData(commodity.colorList)
        
        sizeTitleLabel.setPink18(text: "尺寸")
        sizeCollectionView.setData(commodity.sizeList)
        
        stockTitleLabel.setPink18(text: "商品庫存")
        
        stockLabel.setBlack18(text: "\(commodity.inventory)")
        
        priceTitleLabel.setPink18(text: "商品價格")
        priceLabel.setBlack18(text: "\(commodity.price)")
        
        addButton.setTitle("加入購物車", for: .normal)
        
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }
    
    private func setupLayout() {
        safeEdgesView.addSubview(closeImageView) { make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview().offset(54)
            make.trailing.equalToSuperview().offset(-78)
        }
        
        safeEdgesView.addSubview(imageView) { make in
            make.width.height.equalTo(220)
            make.top.equalToSuperview().offset(110)
            make.trailing.equalToSuperview().offset(-166)
        }
        
        safeEdgesView.addSubview(containerView) { make in
            make.leading.equalToSuperview().offset(102)
            make.top.equalTo(imageView)
            make.trailing.equalTo(imageView.snp.leading).offset(-30)
            make.bottom.equalToSuperview().offset(-36)
        }
        
        containerView.addSubview(snTitleLabel) { make in
            make.leading.top.equalToSuperview()
        }
        containerView.addSubview(snLabel) { make in
            make.centerY.equalTo(snTitleLabel)
            make.leading.equalTo(snTitleLabel.snp.trailing).offset(42)
        }
        
        containerView.addSubview(nameTitleLabel) { make in
            make.leading.equalToSuperview()
            make.top.equalTo(snTitleLabel.snp.bottom).offset(50)
        }
        containerView.addSubview(nameLabel) { make in
            make.centerY.equalTo(nameTitleLabel)
            make.leading.equalTo(nameTitleLabel.snp.trailing).offset(42)
        }
        
        containerView.addSubview(colorTitleLabel) { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(50)
        }
        containerView.addSubview(colorCollectionView) { make in
            make.height.equalTo(38)
            make.centerY.equalTo(colorTitleLabel)
            make.leading.equalTo(colorTitleLabel.snp.trailing).offset(42)
            make.trailing.equalToSuperview()
        }
        
        containerView.addSubview(sizeTitleLabel) { make in
            make.leading.equalToSuperview()
            make.top.equalTo(colorTitleLabel.snp.bottom).offset(50)
        }
        
        containerView.addSubview(stockTitleLabel) { make in
            make.leading.bottom.equalToSuperview()
        }
        
        containerView.addSubview(stockLabel) { make in
            make.leading.equalTo(stockTitleLabel.snp.trailing).offset(28)
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(priceTitleLabel) { make in
            make.leading.equalTo(stockLabel.snp.trailing).offset(50)
            make.bottom.equalToSuperview()
        }
        containerView.addSubview(priceLabel) { make in
            make.leading.equalTo(priceTitleLabel.snp.trailing).offset(42)
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(sizeCollectionView) { make in
            make.top.equalTo(sizeTitleLabel)
            make.leading.equalTo(sizeTitleLabel.snp.trailing).offset(42)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(stockTitleLabel.snp.top).offset(-36)
        }
        
        safeEdgesView.addSubview(addButton) { make in
            make.width.equalTo(146)
            make.height.equalTo(42)
            make.trailing.equalToSuperview().offset(-102)
            make.bottom.equalToSuperview().offset(-36)
        }
    }
    
    private let closeImageView = UIImageView()
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let snTitleLabel = UILabel()
    private let snLabel = UILabel()
    private let nameTitleLabel = UILabel()
    private let nameLabel = UILabel()
    private let colorTitleLabel = UILabel()
    private let colorCollectionView = CommodityDetailColorCollectionView()
    private let sizeTitleLabel = UILabel()
    private let sizeCollectionView = CommodityDetailSizeCollectionView()
    private let stockTitleLabel = UILabel()
    private let stockLabel = UILabel()
    private let priceTitleLabel = UILabel()
    private let priceLabel = UILabel()
    private let addButton = SolidButton()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
