//
//  CheckoutCommodityUiModel.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2025/1/3.
//

import Foundation

public struct CheckoutCommodityUiModel: Hashable {
    
    public enum OtherFee {
        case deliverFee
        case balanceFee
    }
    
    public let uuid = UUID().uuidString
    public let id: Int
    public let sn: String
    public var name: String
    public let color: CommodityColorUiModel?
    public let size: CommoditySizeUiModel?
    public let price: Int
    public let inventory: Int
    public var count: Int
    public var amount: Int { price * count }
    
    public func isSame(_ other: CheckoutCommodityUiModel) -> Bool {
        id == other.id
    }
}

public struct CheckoutCommoditySummary: Hashable {
    public var count: Int
    public var amount: Int
    
    public static var empty: CheckoutCommoditySummary {
        CheckoutCommoditySummary(count: 0, amount: 0)
    }
}
