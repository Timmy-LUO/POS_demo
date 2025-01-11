//
//  CheckoutPaymentCardInstallmentDetailViewController.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/11.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwiftExt

public final class CheckoutPaymentCardInstallmentDetailViewController: BaseTitleDialogViewController {
    
    private var bankType: BankType?
    private var installment: CheckoutPaymentInstallmentUiModel!
    private weak var viewModel: CheckoutPaymentViewModelType!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding() {
        if bankType != .taishin {
            viewModel.outputs
                .bankList
                .drive(onNext: { [weak self] list in
                    self?.pickerView.setData(list: list, emitFirst: true)
                })
                .disposed(by: disposeBag)
        }
        
        cardNumberInputView.isEmptyObservable
            .bind(to: bottomButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        bottomButton.rx
            .tap
            .withLatestFrom(pickerView.contentRelay.unwrap())
            .subscribe(onNext: { [weak self] bank in
                guard let self = self else { return }
                if Int(self.cardNumberInputView.content) == nil {
                    AlertDialogViewController.Builder()
                        .setTitle("請輸入可用數字")
                        .show()
                } else if self.cardNumberInputView.content.count != 4 {
                    AlertDialogViewController.Builder()
                        .setTitle("請輸入信用卡末四碼")
                        .show()
                } else {
                    var newBank = bank
                    newBank.number = self.cardNumberInputView.content
                    newBank.isInstallment = (self.installment.installment == true) ? true : false
                    self.inputAmount(bank: newBank)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func inputAmount(bank: CheckoutPaymentCardUiModel) {
        let vc = CheckoutPaymentCardAmountViewController.Builder()
            .setBank(bank)
            .setViewModel(viewModel)
            .build()
        present(vc, animated: true)
    }
    
    override internal func setupUI() {
        super.setupUI()
        showBottomButton = true
        titleLabel.text = bankType == .taishin ? "台新" : "聯合"
        installmentCountLabel.setBlack20(text: installment.installment ? "分3期" : "不分期")
        pickerTitleLabel.setPink20(text: "選擇銀行代碼")
        
        if bankType == .taishin {
            pickerView.contentRelay.accept(
                CheckoutPaymentCardUiModel(
                    id: 1,
                    bankId: nil,
                    bank: "台新銀行",
                    other: .taishin
                )
            )
        }
    }
    
    override internal func setupLayout() {
        super.setupLayout()
        containerView.addSubview(installmentCountLabel) { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(52)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        
        if bankType == .union {
            let view = UIView()
            view.addSubview(pickerTitleLabel) { make in
                make.width.equalTo(164)
                make.centerY.equalToSuperview()
            }
            view.addSubview(pickerView) { make in
                make.width.equalTo(234)
                make.height.equalTo(38)
                make.leading.equalTo(pickerTitleLabel.snp.trailing)
                make.trailing.equalToSuperview()
                make.top.bottom.equalToSuperview()
            }
            stackView.addArrangedSubview(view)
        }
        
        cardNumberInputView.snp.makeConstraints { make in
            make.width.equalTo(398)
            make.height.equalTo(38)
        }
        stackView.addArrangedSubview(cardNumberInputView)
        
        containerView.addSubview(stackView) { make in
            make.leading.equalToSuperview().offset(210)
            make.top.equalTo(installmentCountLabel.snp.bottom).offset(34)
            make.trailing.equalToSuperview().offset(-210)
            make.bottom.equalToSuperview().offset(-84)
        }
    }
    
    private let installmentCountLabel = UILabel()
    private let pickerTitleLabel = UILabel()
    private let pickerView = PickerInputView<CheckoutPaymentCardUiModel>(
        border: .black,
        isNotEditable: true,
        pickerTitle: "選擇銀行代碼"
    )
    private let cardNumberInputView = POSDemoInputView(title: "信用卡末四碼", titleWidth: 164)
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    public class Builder {
        
        private var bankType: BankType!
        private var installment: CheckoutPaymentInstallmentUiModel!
        private weak var viewModel: CheckoutPaymentViewModelType!
        
        public func setBank(_ type: BankType) -> Self {
            self.bankType = type
            return self
        }
        
        public func setInstallment(_ installment: CheckoutPaymentInstallmentUiModel) -> Self {
            self.installment = installment
            return self
        }
        
        public func setViewModel(_ viewModel: CheckoutPaymentViewModelType) -> Self {
            self.viewModel = viewModel
            return self
        }
        
        public func build() -> CheckoutPaymentCardInstallmentDetailViewController {
            let vc = CheckoutPaymentCardInstallmentDetailViewController()
            vc.bankType = bankType
            vc.installment = installment
            vc.viewModel = viewModel
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            return vc
        }
    }
}
