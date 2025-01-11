//
//  CheckoutUiModel.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/9.
//

public struct CheckoutUiModel {
    public var commodityList: [CheckoutCommodityUiModel] = []
    public var amount: Int
    public var ubn: String?
    public var carrier: String?
    public var cash: Int = 0
    public var cardList: [CheckoutPaymentCardUiModel] = []
    public var giveChange: Int = 0
    
    public func pay() -> (Int, Int) {
        let cardPayment = cardList.map { $0.amount }.reduce(0, +)
        let total = commodityList.map { $0.amount }.reduce(0, +)
        let diff = total - (cash + cardPayment)
        let unpaid = (diff > 0) ? diff : 0
        return (total, unpaid)
    }

    public func change() -> Int {
        var change = 0
        if cardList.isEmpty {
            change = cash - amount
        } else {
            let cardPayment = cardList.map { $0.amount }.reduce(0, +)
            let reduceCard = amount - cardPayment
            if reduceCard > 0 {
                change = cash - reduceCard
            } else {
                change = 0
            }
        }
        return (change >= 0) ? change : -1
    }

    public func isEnough() -> Bool {
        pay().1 == 0
    }
}
