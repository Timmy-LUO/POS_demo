//
//  CheckoutPaymentCardViewController.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class CheckoutPaymentCardViewController: BaseTitleDialogViewController {
    
    private weak var viewModel: CheckoutPaymentViewModelType!
    private let checkAmountRelay = PublishRelay<()>()
    
    public init(viewModel: CheckoutPaymentViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding() {
        checkAmountRelay
            .withLatestFrom(viewModel.outputs.topInfo)
            .subscribe(onNext: { [weak self] (_, unpaid) in
                self?.linePayConfirm(unpaid)
            })
            .disposed(by: disposeBag)
    }
    
    override internal func setupUI() {
        super.setupUI()
        showBottomButton = false
        titleLabel.text = "信用卡"
        descLabel.setPink20(text: "選擇項目")
        taishinButton.setTitle("台新", for: .normal)
        taishinButton.addTarget(self, action: #selector(useTaishin), for: .touchUpInside)
        unionButton.setTitle("聯合", for: .normal)
        unionButton.addTarget(self, action: #selector(useUnion), for: .touchUpInside)
        linePayButton.setTitle("LINE PAY", for: .normal)
        linePayButton.addTarget(self, action: #selector(useLinePay), for: .touchUpInside)
    }
    
    @objc
    private func useTaishin() {
        let vc = CheckoutPaymentCardInstallmentViewController.Builder()
            .setBank(.taishin)
            .setViewModel(viewModel)
            .build()
        present(vc, animated: true)
    }
    
    @objc
    private func useUnion() {
        let vc = CheckoutPaymentCardInstallmentViewController.Builder()
            .setBank(.union)
            .setViewModel(viewModel)
            .build()
        present(vc, animated: true)
    }
    
    @objc
    private func useLinePay() {
        checkAmountRelay.accept(())
    }
    
    private func linePayConfirm(_ amount: Int) {
        POSDemoTitleInputDialogViewController.Builder()
            .setTitle("LINE PAY")
            .setDesc("請輸入刷卡金額")
            .setTextFieldWidth(235)
            .setButton("確認") { [weak self] result in
                if Int(result) == nil || Int(result)! <= 0 {
                    AlertDialogViewController.Builder()
                        .setTitle("請輸入可用數字")
                        .show()
                } else if amount < Int(result)! {
                    AlertDialogViewController.Builder()
                        .setTitle("輸入金額不可大於未付金額")
                        .show()
                } else {
                    let newBank = CheckoutPaymentCardUiModel(
                        id: -1,
                        bankId: "-1",
                        bank: "LINE PAY",
                        other: .linePay,
                        amount: Int(result) ?? 0
                    )
                    self?.viewModel.inputs.useCard.accept(newBank)
                    self?.dismiss(animated: true)
                }
            }
            .show()
    }
    
    override internal func setupLayout() {
        super.setupLayout()
        containerView.addSubview(descLabel) { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(52)
        }
        
        buttonList.forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(110)
                make.height.equalTo(40)
            }
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.addArrangedSubview(taishinButton)
        stackView.addArrangedSubview(unionButton)
        stackView.addArrangedSubview(linePayButton)
        
        containerView.addSubview(stackView) { make in
            make.leading.equalToSuperview().offset(142)
            make.trailing.equalToSuperview().offset(-142)
            make.top.equalTo(descLabel.snp.bottom).offset(34)
            make.bottom.equalToSuperview().offset(-156)
        }
    }
    
    private let descLabel = UILabel()
    private let taishinButton = HollowButton()
    private let unionButton = HollowButton()
    private let linePayButton = HollowButton()
    private var buttonList: [UIButton] { [taishinButton, unionButton, linePayButton] }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
