//
//  CheckoutReviewViewModel.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/8.
//

import RxCocoa
import RxSwift
import RxSwiftExt

public protocol CheckoutReviewViewModelInputs: AnyObject {
    var onCheckout: PublishRelay<[CheckoutCommodityUiModel]> { get }
}

public protocol CheckoutReviewViewModelOutputs: AnyObject {
    var summary: Signal<CheckoutUiModel> { get }
}

public protocol CheckoutReviewViewModelType: AnyObject {
    var inputs: CheckoutReviewViewModelInputs { get }
    var outputs: CheckoutReviewViewModelOutputs { get }
}

public final class CheckoutReviewViewModel:
    CheckoutReviewViewModelInputs,
    CheckoutReviewViewModelOutputs,
    CheckoutReviewViewModelType
{
    private let disposeBag = DisposeBag()
    
    public var inputs: CheckoutReviewViewModelInputs { self }
    public var outputs: CheckoutReviewViewModelOutputs { self }
    
    // inputs
    public var onCheckout = PublishRelay<[CheckoutCommodityUiModel]>()
    
    // outputs
    public var summary: Signal<CheckoutUiModel> { _summary.asSignal() }
    
    // internals
    private let _summary = PublishRelay<CheckoutUiModel>()
    
    public init() {
        onCheckout
            .subscribe(onNext: { [weak self] commodityList in
                let model = CheckoutUiModel(
                    commodityList: commodityList,
                    amount: commodityList.map { $0.amount }.reduce(0, +)
                )
                self?._summary.accept(model)
            })
            .disposed(by: disposeBag)
    }
}
