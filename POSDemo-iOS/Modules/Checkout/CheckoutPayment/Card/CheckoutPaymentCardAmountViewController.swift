//
//  CheckoutPaymentCardAmountViewController.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/11.
//

import UIKit
import SnapKit
import RxCocoa

public final class CheckoutPaymentCardAmountViewController: BaseTitleDialogViewController {
    
    private var bank: CheckoutPaymentCardUiModel!
    private weak var viewModel: CheckoutPaymentViewModelType!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding() {
        amountInputView.isEmptyObservable
            .bind(to: bottomButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        bottomButton.rx
            .tap
            .withLatestFrom(viewModel.outputs.topInfo)
            .subscribe(onNext: { [weak self] amount in
                guard let self = self else { return }
                if Int(self.amountInputView.content) == nil || Int(self.amountInputView.content)! <= 0 {
                    AlertDialogViewController.Builder()
                        .setTitle("請輸入可用數字")
                        .show()
                } else if amount.1 < Int(self.amountInputView.content)! {
                    AlertDialogViewController.Builder()
                        .setTitle("輸入金額不可大於未付金額")
                        .show()
                } else {
                    var newBank = self.bank!
                    newBank.amount = Int(self.amountInputView.content) ?? 0
                    self.viewModel.inputs.useCard.accept(newBank)
                    self.dismiss()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func dismiss() {
        presentingViewController?
            .presentingViewController?
            .presentingViewController?
            .presentingViewController?
            .dismiss(animated: true)
    }
    
    override internal func setupUI() {
        super.setupUI()
        showBottomButton = true
        titleLabel.text = bank._title
        installmentCountLabel.setBlack20(text: bank.isInstallment ? "分3期" : "不分期")
    }
    
    override internal func setupLayout() {
        super.setupLayout()
        containerView.addSubview(installmentCountLabel) { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(52)
        }
        
        containerView.addSubview(amountInputView) { make in
            make.width.equalTo(398)
            make.height.equalTo(38)
            make.leading.equalToSuperview().offset(210)
            make.top.equalTo(installmentCountLabel.snp.bottom).offset(34)
            make.trailing.equalToSuperview().offset(-210)
            make.bottom.equalToSuperview().offset(-84)
        }
    }
    
    private let installmentCountLabel = UILabel()
    private let amountInputView = POSDemoInputView(title: "請輸入刷卡金額", titleWidth: 164)
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    public class Builder {
        
        private var bank: CheckoutPaymentCardUiModel!
        private weak var viewModel: CheckoutPaymentViewModelType!
        
        public func setBank(_ bank: CheckoutPaymentCardUiModel) -> Self {
            self.bank = bank
            return self
        }
        
        public func setViewModel(_ viewModel: CheckoutPaymentViewModelType) -> Self {
            self.viewModel = viewModel
            return self
        }
        
        public func build() -> CheckoutPaymentCardAmountViewController {
            let vc = CheckoutPaymentCardAmountViewController()
            vc.bank = bank
            vc.viewModel = viewModel
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            return vc
        }
    }
}

