//
//  CheckoutPaymentViewModel.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/10.
//

import RxSwift
import RxCocoa
import RxRelay
import RxSwiftExt

public protocol CheckoutPaymentViewModelInputs: AnyObject {
    var summary: BehaviorRelay<CheckoutUiModel?> { get }
    var onClearPay: PublishRelay<()> { get }
    var useCash: BehaviorRelay<Int> { get }
    var useCard: PublishRelay<CheckoutPaymentCardUiModel> { get }
    var useUbn: BehaviorRelay<String?> { get }
    var useCarrier: BehaviorRelay<String?> { get }
}

public protocol CheckoutPaymentViewModelOutputs: AnyObject {
    var topInfo: Driver<(Int, Int)> { get }
    var leftTableInfo: Driver<[CheckoutPaymentItemUiModel]> { get }
    var rightTableInfo: Driver<[CheckoutPaymentItemUiModel]> { get }
    var bankList: Driver<[CheckoutPaymentCardUiModel]> { get }
}

public protocol CheckoutPaymentViewModelType: AnyObject {
    var inputs: CheckoutPaymentViewModelInputs { get }
    var outputs: CheckoutPaymentViewModelOutputs { get }
}

public final class CheckoutPaymentViewModel:
    CheckoutPaymentViewModelInputs,
    CheckoutPaymentViewModelOutputs,
    CheckoutPaymentViewModelType
{
    private let disposeBag = DisposeBag()
    
    public var inputs: CheckoutPaymentViewModelInputs { self }
    public var outputs: CheckoutPaymentViewModelOutputs { self }
    
    // inputs
    public var summary = BehaviorRelay<CheckoutUiModel?>(value: nil)
    public var onClearPay = PublishRelay<()>()
    public var useCash = BehaviorRelay<Int>(value: 0)
    public var useCard = PublishRelay<CheckoutPaymentCardUiModel>()
    public var useUbn = BehaviorRelay<String?>(value: nil)
    public var useCarrier = BehaviorRelay<String?>(value: nil)
    
    // outputs
    public var topInfo: Driver<(Int, Int)> { _topInfo.asDriver() }
    public var leftTableInfo: Driver<[CheckoutPaymentItemUiModel]> { _leftTableInfo.asDriver() }
    public var rightTableInfo: Driver<[CheckoutPaymentItemUiModel]> { _rightTableInfo.asDriver() }
    public var bankList: Driver<[CheckoutPaymentCardUiModel]> { _bankList.asDriver() }
    
    // internals
    private let _topInfo = BehaviorRelay<(Int, Int)>(value: (0, 0))
    private let _leftTableInfo = BehaviorRelay<[CheckoutPaymentItemUiModel]>(value: [])
    private let _rightTableInfo = BehaviorRelay<[CheckoutPaymentItemUiModel]>(value: [])
    private let _usedCardList = BehaviorRelay<[CheckoutPaymentCardUiModel]>(value: [])
    private let _bankList = BehaviorRelay<[CheckoutPaymentCardUiModel]>(value: [])
    
    public init() {
        summary
            .unwrap()
            .map(handleLeftTableInfo)
            .bind(to: _leftTableInfo)
            .disposed(by: disposeBag)
        
        summary
            .unwrap()
            .map(handleRightTableInfo)
            .bind(to: _rightTableInfo)
            .disposed(by: disposeBag)
        
        onClearPay
            .withLatestFrom(summary.unwrap())
            .subscribe(onNext: { [weak self] summary in
                self?.clearPay(summary)
            })
            .disposed(by: disposeBag)
        
        useCash
            .withLatestFrom(summary.unwrap()) {
                var newModel = $1
                newModel.cash = $0
                return newModel
            }
            .bind(to: summary)
            .disposed(by: disposeBag)
        
        useCard
            .withLatestFrom(_usedCardList)  { ($0, $1) }
            .subscribe(onNext: { [weak self] card, usedCardList in
                var newList = usedCardList
                if let index = usedCardList.firstIndex(where: {
                    ($0.bankId == card.bankId)
                    && ($0.number == card.number)
                    && ($0.isInstallment == card.isInstallment)
                }) {
                    newList[index].amount += card.amount
                } else {
                    newList.append(card)
                }
                self?._usedCardList.accept(newList)
            })
            .disposed(by: disposeBag)
        
        _usedCardList
            .withLatestFrom(summary.unwrap()) {
                var newModel = $1
                newModel.cardList = $0
                return newModel
            }
            .bind(to: summary)
            .disposed(by: disposeBag)
        
        useUbn
            .withLatestFrom(summary.unwrap()) {
                var newModel = $1
                newModel.ubn = $0
                return newModel
            }
            .bind(to: summary)
            .disposed(by: disposeBag)
        
        useCarrier
            .withLatestFrom(summary.unwrap()) {
                var newModel = $1
                newModel.carrier = $0
                return newModel
            }
            .bind(to: summary)
            .disposed(by: disposeBag)
        
        getBank()
    }
    
    private func handleLeftTableInfo(model: CheckoutUiModel) -> [CheckoutPaymentItemUiModel] {
        var list = [CheckoutPaymentItemUiModel]()
        _topInfo.accept(model.pay())
        
        if model.cash > 0 {
            list.append(CheckoutPaymentItemUiModel(title: "現金金額", content: model.cash.formatted))
        }
        
        for card in model.cardList {
            var content = ""
            if let number = card.number {
                content = "卡號\(number)"
            }
            if card.isInstallment {
                content += "  分3期 \(card.amount.formatted)"
            } else {
                content += "  \(card.amount.formatted)"
            }
            list.append(CheckoutPaymentItemUiModel(title: card.bank, content: content))
        }
        
        return list
    }
    
    private func handleRightTableInfo(model: CheckoutUiModel) -> [CheckoutPaymentItemUiModel] {
        var list = [CheckoutPaymentItemUiModel]()
        
        if let ubn = model.ubn {
            list.append(CheckoutPaymentItemUiModel(title: "統一編號", content: ubn))
        }
        
        if let carrier = model.carrier {
            list.append(CheckoutPaymentItemUiModel(title: "電子載具", content: carrier))
        }
        
        return list
    }
    
    private func clearPay(_ summary: CheckoutUiModel) {
        var newSummary = summary
        newSummary.cash = 0
        newSummary.cardList = []
        self.summary.accept(newSummary)
    }
    
    private func getBank() {
        _bankList.accept(CheckoutPaymentCardUiModel.mock())
    }
}
