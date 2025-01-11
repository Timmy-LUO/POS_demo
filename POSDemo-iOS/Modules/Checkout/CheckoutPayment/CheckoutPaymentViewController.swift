//
//  CheckoutPaymentViewController.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/8.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxSwiftExt

public final class CheckoutPaymentViewController: BaseViewController {
    
    private weak var parentCoordinator: WelcomeCoordinator!
    private let viewModel: CheckoutPaymentViewModelType!
    private let popRelay = PublishRelay<()>()
    
    public init(
        _ parentCoordinator: WelcomeCoordinator,
        viewModel: CheckoutPaymentViewModelType
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
        viewModel.outputs
            .topInfo
            .drive(onNext: { [weak self] amount, unpaid in
                self?.amountLabel.text = "$ \(amount.formatted)"
                self?.unpaidLabel.text = "$ \(unpaid.formatted)"
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .leftTableInfo
            .drive(onNext: { [weak self] info in
                self?.leftTableView.setData(info)
                if !info.isEmpty {
                    self?.clearPayButton.isHidden = false
                } else {
                    self?.clearPayButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .rightTableInfo
            .drive(onNext: { [weak self] info in
                self?.rightTableView.setData(info)
            })
            .disposed(by: disposeBag)
        
        cashButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.showCashDialog()
            })
            .disposed(by: disposeBag)
        
        cardButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.useCardDialog()
            })
            .disposed(by: disposeBag)
        
        carrierButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.showCarrierDialog()
            })
            .disposed(by: disposeBag)
        
        checkoutButton.rx
            .tap
            .withLatestFrom(viewModel.inputs.summary.unwrap())
            .subscribe(onNext: { [weak self] summary in
                if !summary.isEnough() {
                    self?.showMessageDialog("請確實付款！")
                    return
                }
                self?.popRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        popRelay
            .withLatestFrom(viewModel.inputs.summary.unwrap())
            .subscribe(onNext: { [weak self] summary in
                self?.showChange(giveChange: summary.change())
            })
            .disposed(by: disposeBag)
    }
    
    private func showCashDialog() {
        POSDemoTitleInputDialogViewController.Builder()
            .setTitle("現金")
            .setDesc("請輸入金額")
            .setTextFieldWidth(180)
            .setButton("確認") { [weak self] result in
                if let cash = Int(result) {
                    self?.viewModel.inputs.useCash.accept(cash)
                } else {
                    self?.showMessageDialog("請輸入有效數字")
                }
            }
            .show()
    }
    
    private func useCardDialog() {
        let vc = CheckoutPaymentCardViewController(viewModel: viewModel)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    private func showCarrierDialog() {
        POSDemoTitleInputDialogViewController.Builder()
            .setTitle("載具")
            .setDesc("請輸入載具號碼")
            .setTextFieldWidth(180)
            .setButton("確認") { [weak self] carrier in
                self?.viewModel.inputs.useCarrier.accept(carrier)
            }
            .show()
    }
    
    @objc
    private func showUbnDialog() {
        POSDemoTitleInputDialogViewController.Builder()
            .setTitle("統一編號")
            .setDesc("請輸入統一編號")
            .setTextFieldWidth(180)
            .setButton("確認") { [weak self] ubn in
                if ubn.count == 8 {
                    self?.viewModel.inputs.useUbn.accept(ubn)
                } else {
                    self?.showMessageDialog("統一編號為8碼")
                }
            }
            .show()
    }
    
    @objc
    private func clearPay() {
        viewModel.inputs.onClearPay.accept(())
    }
    
    private func showChange(giveChange: Int) {
        AlertDialogViewController.Builder()
            .setTitle("找零金額  $\(giveChange)")
            .setRightButton { [weak self] in
                self?.pop()
            }
            .show()
    }
    
    private func pop() {
        navigationController?.popTo(CheckoutReviewViewController.self) { vc in
            vc.clear()
        }
    }
    
    private func showMessageDialog(_ content: String) {
        AlertDialogViewController.Builder()
            .setTitle(content)
            .show()
    }
    
    private func setupUI() {
        closeButton.setTitle("返回", for: .normal)
        closeButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        amountTitleLabel.setBlack20(text: "應付金額")
        amountLabel.font = .boldSystemFont(ofSize: 50)
        amountLabel.autoFontSize()
        
        unpaidTitleLabel.setBlack20(text: "未付金額")
        unpaidLabel.font = .boldSystemFont(ofSize: 50)
        unpaidLabel.autoFontSize()
        unpaidLabel.textAlignment = .right
        
        separator.backgroundColor = "text_black_light".color
        
        clearPayButton.setTitle("清空付款", for: .normal)
        clearPayButton.addTarget(self, action: #selector(clearPay), for: .touchUpInside)
        
        pointButton.setGray()
        pointButton.setTitle("點數扣款", for: .normal)
        
        ubnButton.setGray()
        ubnButton.setTitle("統一編號", for: .normal)
        ubnButton.addTarget(self, action: #selector(showUbnDialog), for: .touchUpInside)
        
        carrierButton.setGray()
        carrierButton.setTitle("電子載具", for: .normal)
        
        paymentTitleLabel.setPink20(text: "選擇付款方式")
        
        cashButton.setYellow()
        cashButton.set(title: "現金", titleColor: "text_black".color, image: "ic_checkout_cash".image)
        
        cardButton.setYellow()
        cardButton.set(title: "信用卡", titleColor: "text_black".color, image: "ic_checkout_card".image)
        
        shoppingMoneyButton.setYellow()
        shoppingMoneyButton.set(title: "購物金", titleColor: "text_black".color, image: "ic_checkout_shopping_money".image)
        
        otherButton.setYellow()
        otherButton.set(title: "其他付款", titleColor: "text_black".color, image: "ic_checkout_other".image)
        
        checkoutButton.setPink()
        checkoutButton.set(title: "結帳", titleColor: .white, image: "ic_checkout_checkout".image)
    }

    private func setupLayout() {
        safeEdgesView.addSubview(closeButton) { make in
            make.width.equalTo(96)
            make.height.equalTo(58)
            make.top.equalToSuperview().offset(26)
            make.leading.equalToSuperview().offset(36)
        }
        
        let leftSpacingView = UIView()
        let rightSpacingView = UIView()
        
        safeEdgesView.addSubview(amountTitleLabel)
        safeEdgesView.addSubview(amountLabel)
        safeEdgesView.addSubview(leftSpacingView)
        safeEdgesView.addSubview(unpaidTitleLabel)
        safeEdgesView.addSubview(unpaidLabel)
        safeEdgesView.addSubview(rightSpacingView)
        safeEdgesView.addSubview(separator)
        
        amountTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountLabel)
            make.leading.equalTo(separator).offset(10)
        }
        amountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(58)
            make.leading.equalTo(amountTitleLabel.snp.trailing).offset(30)
            make.trailing.equalTo(leftSpacingView.snp.leading)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(190)
            make.top.equalTo(amountLabel.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-190)
        }
        
        unpaidLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountLabel)
            make.trailing.equalTo(separator).offset(-10)
        }
        unpaidTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountLabel)
            make.leading.equalTo(rightSpacingView.snp.trailing)
            make.trailing.equalTo(unpaidLabel.snp.leading).offset(-30)
        }
        
        leftSpacingView.snp.makeConstraints { make in
            make.top.bottom.equalTo(amountLabel)
            make.trailing.greaterThanOrEqualTo(separator.snp.centerX).offset(-10)
        }
        rightSpacingView.snp.makeConstraints { make in
            make.top.bottom.equalTo(amountLabel)
            make.leading.greaterThanOrEqualTo(separator.snp.centerX).offset(10)
        }
        
        safeEdgesView.addSubview(checkoutButton) { make in
            make.width.equalTo(700)
            make.height.equalTo(58)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
        
        buttonList.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(58)
            }
        }
        
        let bottomButtonStackView = UIStackView()
        bottomButtonStackView.axis = .horizontal
        bottomButtonStackView.spacing = 35
        bottomButtonStackView.addArrangedSubview(cashButton)
        bottomButtonStackView.addArrangedSubview(cardButton)
        bottomButtonStackView.addArrangedSubview(shoppingMoneyButton)
        bottomButtonStackView.addArrangedSubview(otherButton)
        safeEdgesView.addSubview(bottomButtonStackView) { make in
            make.width.equalTo(700)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(checkoutButton.snp.top).offset(-20)
        }
        
        safeEdgesView.addSubview(paymentTitleLabel) { make in
            make.leading.equalTo(bottomButtonStackView.snp.leading)
            make.bottom.equalTo(bottomButtonStackView.snp.top).offset(-20)
        }
        
        let topButtonStackView = UIStackView()
        topButtonStackView.axis = .horizontal
        topButtonStackView.spacing = 50
        topButtonStackView.distribution = .fillEqually
        topButtonStackView.addArrangedSubview(pointButton)
        topButtonStackView.addArrangedSubview(ubnButton)
        topButtonStackView.addArrangedSubview(carrierButton)
        safeEdgesView.addSubview(topButtonStackView) { make in
            make.width.equalTo(700)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(paymentTitleLabel.snp.top).offset(-20)
        }
        
        safeEdgesView.addSubview(clearPayButton) { make in
            make.width.equalTo(700)
            make.height.equalTo(36)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(topButtonStackView.snp.top).offset(-20)
        }
        
        safeEdgesView.addSubview(leftTableView) { make in
            make.leading.equalTo(amountTitleLabel)
            make.top.equalTo(separator).offset(40)
            make.trailing.equalTo(separator.snp.centerX)
            make.bottom.equalTo(clearPayButton.snp.top).offset(-40)
        }
        
        safeEdgesView.addSubview(rightTableView) { make in
            make.leading.equalTo(separator.snp.centerX)
            make.top.equalTo(separator).offset(40)
            make.trailing.equalTo(separator).offset(-40)
            make.bottom.equalTo(clearPayButton.snp.top).offset(-40)
        }
    }
    
    private let closeButton = WhiteShadowButton()
    private let amountTitleLabel = UILabel()
    private let amountLabel = UILabel()
    private let unpaidTitleLabel = UILabel()
    private let unpaidLabel = UILabel()
    private let separator = UIView()
    private let leftTableView = CheckoutPaymentTableView()
    private let rightTableView = CheckoutPaymentTableView()
    private let clearPayButton = HollowButton()
    private let pointButton = UIButton()
    private let ubnButton = UIButton()
    private let carrierButton = UIButton()
    private let paymentTitleLabel = UILabel()
    private let cashButton = UIButton(type: .custom)
    private let cardButton = UIButton(type: .custom)
    private let shoppingMoneyButton = UIButton(type: .custom)
    private let otherButton = UIButton(type: .custom)
    private let checkoutButton = UIButton(type: .custom)
    private var buttonList: [UIButton] {
        [pointButton, ubnButton, carrierButton, cashButton, cardButton, shoppingMoneyButton, otherButton]
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}

fileprivate extension UIButton {
    func setGray() {
        titleLabel?.font = .systemFont(ofSize: 20)
        setTitleColor("text_black".color, for: .normal)
        backgroundColor = "separator_grey".color
        
        layer.shadowOpacity = 0.06
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func setYellow() {
        backgroundColor = "login_view_button".color
        
        layer.cornerRadius = 2
        layer.shadowColor = "login_view_button".color.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func setPink() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 22)
        backgroundColor = "bg_pink".color
        
        layer.cornerRadius = 2
        layer.shadowColor = "bg_pink".color.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func set(title: String, titleColor: UIColor, image: UIImage) {
        configuration = UIButton.Configuration.plain()
        configuration?.imagePadding = 20
        setImage(image, for: .normal)
        
        var attText = AttributedString(title)
        attText.foregroundColor = titleColor
        attText.font = .systemFont(ofSize: 18)
        configuration?.attributedTitle = attText
    }
}
