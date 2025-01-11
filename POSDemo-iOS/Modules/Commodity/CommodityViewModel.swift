//
//  CommodityViewModel.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2024/12/5.
//

import RxCocoa
import RxSwift
import RxSwiftExt

public protocol CommodityViewModelInputs: AnyObject {
    var commodityFilter: BehaviorRelay<String> { get }
    var commodityLabel: BehaviorRelay<String?> { get }
    var toRootCommodityLabel: PublishRelay<()> { get }
    var onSelectedColor: BehaviorRelay<CommodityColorUiModel?> { get }
    var onSelectedSize: BehaviorRelay<CommoditySizeUiModel?> { get }
    var onConfirmedCommodity: PublishRelay<CommodityUiModel> { get }
    var onIncrementCommodity: PublishRelay<CheckoutCommodityUiModel> { get }
    var onDecreaseCommodity: PublishRelay<CheckoutCommodityUiModel> { get }
    var onClearCommodity: PublishRelay<CheckoutCommodityUiModel> { get }
    var onClearAllCommodity: PublishRelay<()> { get }
}

public protocol CommodityViewModelOutputs: AnyObject {
    var commodityLabelList: Driver<[String]> { get }
    var commodity: Driver<[CommodityUiModel]> { get }
    var selectedCheckoutCommodityList: Driver<[CheckoutCommodityUiModel]> { get }
    var summary: Driver<CheckoutCommoditySummary> { get }
}

public protocol CommodityViewModelType: AnyObject {
    var inputs: CommodityViewModelInputs { get }
    var outputs: CommodityViewModelOutputs { get }
    
    func clear()
}

public final class CommodityViewModel:
    CommodityViewModelInputs,
    CommodityViewModelOutputs,
    CommodityViewModelType
{
    private let disposeBag = DisposeBag()
    
    public var inputs: CommodityViewModelInputs { self }
    public var outputs: CommodityViewModelOutputs { self }
    
    // inputs
    public var commodityFilter = BehaviorRelay<String>(value: "")
    public var commodityLabel = BehaviorRelay<String?>(value: nil)
    public var toRootCommodityLabel = PublishRelay<()>()
    public var onSelectedColor: BehaviorRelay<CommodityColorUiModel?> = BehaviorRelay<CommodityColorUiModel?>(value: nil)
    public var onSelectedSize: BehaviorRelay<CommoditySizeUiModel?> = BehaviorRelay<CommoditySizeUiModel?>(value: nil)
    public var onConfirmedCommodity: PublishRelay<CommodityUiModel> = PublishRelay<CommodityUiModel>()
    public var onIncrementCommodity = PublishRelay<CheckoutCommodityUiModel>()
    public var onDecreaseCommodity = PublishRelay<CheckoutCommodityUiModel>()
    public var onClearCommodity = PublishRelay<CheckoutCommodityUiModel>()
    public var onClearAllCommodity = PublishRelay<()>()
    
    // outputs
    public var commodityLabelList: Driver<[String]> { _commodityLabelList.asDriver() }
    public var commodity: Driver<[CommodityUiModel]> { _commodity.asDriver() }
    public var selectedCheckoutCommodityList: Driver<[CheckoutCommodityUiModel]> { _selectedCheckoutCommodityList.asDriver() }
    public var summary: Driver<CheckoutCommoditySummary> { _summary.asDriver() }
    
    // internals
    private let _commodityLabelList = BehaviorRelay<[String]>(value: [])
    private let _commodity = BehaviorRelay<[CommodityUiModel]>(value: [])
    private let _selectedCheckoutCommodityList = BehaviorRelay<[CheckoutCommodityUiModel]>(value: [])
    private let _summary = BehaviorRelay<CheckoutCommoditySummary>(value: CheckoutCommoditySummary.empty)
    
    private let _commodityRelay = BehaviorRelay<[CommodityUiModel]>(value: [])
    private let _labelFilteredCommodity = BehaviorRelay<[CommodityUiModel]>(value: [])
    
    public init() {
        
        commodityLabel
            .unwrap()
            .withLatestFrom(_commodityRelay) { ($0, $1) }
            .subscribe(onNext: { [weak self] label, commodityList in
                self?._labelFilteredCommodity.accept(commodityList.filter { $0.labelNameList.contains(label) })
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            commodityFilter,
            _commodityRelay,
            commodityLabel,
            _labelFilteredCommodity,
            resultSelector: { filter, commodityList, selectedLabel, filteredCommodity in
                var list = filteredCommodity
                if filteredCommodity.isEmpty && selectedLabel == nil {
                    list = self._commodityRelay.value
                    if !filter.isEmpty {
                        list = list.filter { ($0.name.contains(filter) || $0.sn.lowercased().contains(filter.lowercased())) }
                    }
                } else {
                    if !filter.isEmpty {
                        list = list.filter { ($0.name.contains(filter) || $0.sn.lowercased().contains(filter.lowercased())) }
                    }
                }
                return list
            }
        )
        .bind(to: _commodity)
        .disposed(by: disposeBag)
        
        toRootCommodityLabel
            .withLatestFrom(_commodityRelay)
            .subscribe(onNext: { [weak self] commodityList in
                self?.commodityLabel.accept(nil)
                self?._commodity.accept(commodityList)
            })
            .disposed(by: disposeBag)
        
        onConfirmedCommodity
            .withLatestFrom(onSelectedColor.unwrap()) { ($0, $1) }
            .withLatestFrom(onSelectedSize.unwrap()) { ($0.0, $0.1, $1) }
            .withLatestFrom(_selectedCheckoutCommodityList) { ($0.0, $0.1, $0.2, $1) }
            .subscribe(onNext: { [weak self] commodity, color, size, checkoutCommodityList in
                let commodityDetail = commodity.toCheckoutModel(color: color, size: size)
                
                var newList = checkoutCommodityList
                if let index = newList.firstIndex(where: { $0.isSame(commodityDetail) }) {
                    newList[index].count += 1
                } else {
                    newList.append(commodityDetail)
                }
                
                self?.handleCheckoutCommodityList(newList)
            })
            .disposed(by: disposeBag)
        
        onIncrementCommodity
            .withLatestFrom(_selectedCheckoutCommodityList) { ($0, $1) }
            .subscribe(onNext: { [weak self] commodity, commodityList in
                if let index = commodityList.firstIndex(where: { $0.isSame(commodity) }) {
                    var newList = commodityList
                    newList[index].count += 1
                    self?.handleCheckoutCommodityList(newList)
                }
            })
            .disposed(by: disposeBag)
        
        onDecreaseCommodity
            .withLatestFrom(_selectedCheckoutCommodityList) { ($0, $1) }
            .subscribe(onNext: { [weak self] commodity, commodityList in
                if let index = commodityList.firstIndex(where: { $0.isSame(commodity) }) {
                    var newList = commodityList
                    newList[index].count -= 1
                    if newList[index].count == 0 {
                        newList.remove(at: index)
                    }
                    self?.handleCheckoutCommodityList(newList)
                }
            })
            .disposed(by: disposeBag)
        
        onClearCommodity
            .withLatestFrom(_selectedCheckoutCommodityList) { ($0, $1) }
            .subscribe(onNext: { [weak self] commodity, commodityList in
                if let index = commodityList.firstIndex(where: { $0.isSame(commodity) }) {
                    var newList = commodityList
                    newList.remove(at: index)
                    self?.handleCheckoutCommodityList(newList)
                }
            })
            .disposed(by: disposeBag)
        
        onClearAllCommodity
            .withLatestFrom(_selectedCheckoutCommodityList) { ($0, $1) }
            .subscribe(onNext: { [weak self] commodity, commodityList in
                var newList = commodityList
                newList = []
                self?.handleCheckoutCommodityList(newList)
            })
            .disposed(by: disposeBag)
        
        loadCommodity()
    }
    
    private func handleCheckoutCommodityList(_ list: [CheckoutCommodityUiModel]) {
        _selectedCheckoutCommodityList.accept(list)
        let summary = CheckoutCommoditySummary(
            count: list.map { $0.count }.reduce(0, +),
            amount: list.map { $0.amount }.reduce(0, +)
        )
        _summary.accept(summary)
    }
    
    private func loadCommodity() {
        _commodityLabelList.accept(CommodityUiModel.commodityLabelMock())
        let commodityList = CommodityUiModel.generateMockCommodities(count: 5)
        _commodity.accept(commodityList)
        _commodityRelay.accept(commodityList)
    }
    
    public func clear() {
        _selectedCheckoutCommodityList.accept([])
        _summary.accept(CheckoutCommoditySummary.empty)
    }
}
