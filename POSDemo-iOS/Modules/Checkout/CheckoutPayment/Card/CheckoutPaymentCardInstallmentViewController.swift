//
//  CheckoutPaymentCardInstallmentViewController.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/11.
//

import UIKit
import SnapKit
import RxSwiftExt

public enum BankType {
    case taishin
    case union
}

public final class CheckoutPaymentCardInstallmentViewController: BaseTitleDialogViewController {
    
    private var bankType: BankType?
    private weak var viewModel: CheckoutPaymentViewModelType!
    
    override internal func onClick() {
        showCardInstallmentDetail()
    }
    
    private func showCardInstallmentDetail() {
        let vc = CheckoutPaymentCardInstallmentDetailViewController.Builder()
            .setBank(bankType!)
            .setInstallment(pickerView.selectedItem!)
            .setViewModel(viewModel)
            .build()
        present(vc, animated: true)
    }
    
    override internal func setupUI() {
        super.setupUI()
        showBottomButton = true
        titleLabel.text = bankType == .taishin ? "台新" : "聯合"
        installmentCountLabel.setPink20(text: "選擇期數")
        pickerView.setData(
            list: [
                CheckoutPaymentInstallmentUiModel(id: 0, title: "不分期", installment: false),
                CheckoutPaymentInstallmentUiModel(id: 0, title: "分3期", installment: true),
            ],
            emitFirst: true
        )
    }
    
    override internal func setupLayout() {
        super.setupLayout()
        containerView.addSubview(installmentCountLabel) { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(52)
        }
        
        containerView.addSubview(pickerView) { make in
            make.width.equalTo(234)
            make.height.equalTo(38)
            make.leading.equalToSuperview().offset(210)
            make.top.equalTo(installmentCountLabel.snp.bottom).offset(34)
            make.trailing.equalToSuperview().offset(-210)
            make.bottom.equalToSuperview().offset(-84)
        }
    }
    
    private let installmentCountLabel = UILabel()
    private let pickerView = PickerInputView<CheckoutPaymentInstallmentUiModel>(
        border: .black,
        isNotEditable: true,
        pickerTitle: "選擇期數"
    )
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    public class Builder {
        
        private var bankType: BankType?
        private weak var viewModel: CheckoutPaymentViewModelType!
        
        public func setBank(_ type: BankType) -> Self {
            self.bankType = type
            return self
        }
        
        public func setViewModel(_ viewModel: CheckoutPaymentViewModelType) -> Self {
            self.viewModel = viewModel
            return self
        }
        
        public func build() -> CheckoutPaymentCardInstallmentViewController {
            let vc = CheckoutPaymentCardInstallmentViewController()
            vc.bankType = bankType
            vc.viewModel = viewModel
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            return vc
        }
    }
}
