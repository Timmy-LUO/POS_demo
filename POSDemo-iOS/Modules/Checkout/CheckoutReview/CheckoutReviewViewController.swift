//
//  CheckoutReviewViewController.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/3.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

public protocol CheckoutReviewViewControllerDelegate: AnyObject {
    func showReviewCommodity()
}

public final class CheckoutReviewViewController: BaseViewController, CheckoutReviewViewControllerDelegate {
    
    private weak var parentCoordinator: WelcomeCoordinator!
    private var currentChild: UIViewController?
    private var isFirst: Bool = false
    private let commodityViewModel: CommodityViewModelType!
    private let checkoutViewModel: CheckoutReviewViewModelType!
    private let checkoutRelay = PublishRelay<()>()
    
    public init(
        _ parentCoordinator: WelcomeCoordinator,
        isFirst: Bool,
        commodityViewModel: CommodityViewModelType,
        checkoutViewModel: CheckoutReviewViewModelType
    ) {
        self.parentCoordinator = parentCoordinator
        self.isFirst = isFirst
        self.commodityViewModel = commodityViewModel
        self.checkoutViewModel = checkoutViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupBinding()
        showReviewCommodity()
    }
    
    private func setupBinding() {
        checkoutRelay
            .withLatestFrom(commodityViewModel.outputs.selectedCheckoutCommodityList)
            .subscribe(onNext: { [weak self] commodityList in
                self?.checkoutViewModel.inputs.onCheckout.accept(commodityList)
            })
            .disposed(by: disposeBag)
        
        checkoutViewModel.outputs
            .summary
            .emit(onNext: { [weak self] summary in
                let viewModel = CheckoutPaymentViewModel()
                viewModel.inputs.summary.accept(summary)
                self?.parentCoordinator.toCheckoutPayment(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
    }
    
    public func clear() {
        commodityViewModel.clear()
    }
    
    @objc
    private func showCommodity() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    public func showReviewCommodity() {
        changeChild(commodityViewController)
    }
    
    private func setupUI() {
        separatorView.backgroundColor = "separator_grey".color
        
        imageView.image = "ic_logo".image
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        branchLabel.setBlack18()
        employeeLabel.setBlack18()
                
        buttonListScrollView.showsVerticalScrollIndicator = false
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.clipsToBounds = false
        functionButtonList.forEach { $0.setup() }
        
        commodityButton.setTitle("全站商品", for: .normal)
        commodityButton.addTarget(self, action: #selector(showCommodity), for: .touchUpInside)
        
        memberButton.setTitle("會員名稱：\n會員代號：\n會員階級：\n剩餘點數：", for: .normal)
        customerButton.setTitle("客類：", for: .normal)
        orderButton.setTitle("訂單 / 付訂", for: .normal)
        saveOrderButton.setTitle("暫存訂單", for: .normal)
        companionButton.setTitle("同行服務", for: .normal)
        alterationButton.setTitle("修改單", for: .normal)
        extraFeeButton.setTitle("其他費用", for: .normal)
        giftButton.setTitle("包裝品：未選", for: .normal)
        exchangeButton.setTitle("退換貨", for: .normal)
    }
    
    private func setupLayout() {
        safeEdgesView.addSubview(separatorView) { make in
            make.width.equalTo(1)
            make.leading.equalToSuperview().offset(256)
            make.top.bottom.equalToSuperview()
        }
        
        safeEdgesView.addSubview(leftSetcionView) { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalToSuperview()
            make.trailing.equalTo(separatorView.snp.leading).offset(-18)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        leftSetcionView.addSubview(imageView) { make in
            make.height.equalTo(180)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(18)
        }
        
        leftSetcionView.addSubview(branchLabel) { make in
            make.width.equalTo(imageView)
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        leftSetcionView.addSubview(employeeLabel) { make in
            make.width.equalTo(imageView)
            make.centerX.equalTo(imageView)
            make.top.equalTo(branchLabel.snp.bottom).offset(12)
        }
        
        leftSetcionView.addSubview(buttonListScrollView) { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(employeeLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
        }
        
        buttonListScrollView.addSubview(buttonStackView) { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
        for button in functionButtonList {
            buttonStackView.addArrangedSubview(button)
        }
        
        safeEdgesView.addSubview(vcContainerView) { make in
            make.leading.equalTo(separatorView.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func changeChild(_ vc: UIViewController) {
        if let currentChild = currentChild {
            currentChild.willMove(toParent: self)
            currentChild.view.removeFromSuperview()
            currentChild.removeFromParent()
        }
        currentChild = vc
        vcContainerView.addSubview(vc.view) { make in
            make.edges.equalToSuperview()
        }
        addChild(vc)
        vc.didMove(toParent: self)
    }
    
    private let separatorView = UIView()
    private let leftSetcionView = UIView()
    private let imageView = UIImageView()
    private let branchLabel = UILabel()
    private let employeeLabel = UILabel()
    private let commodityButton = UIButton(type: .custom)
    private let buttonListScrollView = UIScrollView()
    private let buttonStackView = UIStackView()
    private let memberButton = UIButton(type: .custom)
    private let customerButton = UIButton(type: .custom)
    private let orderButton = UIButton(type: .custom)
    private let saveOrderButton = UIButton(type: .custom)
    private let companionButton = UIButton(type: .custom)
    private let alterationButton = UIButton(type: .custom)
    private let extraFeeButton = UIButton(type: .custom)
    private let giftButton = UIButton(type: .custom)
    private let exchangeButton = UIButton(type: .custom)
    private var functionButtonList: [UIButton] {
        [
            commodityButton, memberButton, customerButton, giftButton,
            saveOrderButton, orderButton, extraFeeButton, companionButton,
            exchangeButton
        ]
    }
    private let vcContainerView = UIView()
    private lazy var commodityViewController: UIViewController = {
        let vc = CheckoutReviewCommodityViewController(commodityViewModel: commodityViewModel)
        vc.delegate = self
        return vc
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}

extension CheckoutReviewViewController: CheckoutReviewCommodityViewControllerDelegate {
    public func onNext() {
        checkoutRelay.accept(())
    }
}

fileprivate extension UIButton {
    func setup() {
        configuration = UIButton.Configuration.plain()
        configuration!.contentInsets = NSDirectionalEdgeInsets(top: 17.0, leading: 0.0, bottom: 17.0, trailing: 0.0)
        layer.cornerRadius = 2
        layer.borderColor = UIColor.red.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 2.5)
        layer.shadowRadius = 3
        clipsToBounds = false
        backgroundColor = .white
        
        setTitleColor("text_brown".color, for: .normal)
        setTitleColor("text_black_light".color, for: .highlighted)
        titleLabel?.font = .systemFont(ofSize: 18)
    }
}
