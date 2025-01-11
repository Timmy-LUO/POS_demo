//
//  CheckoutPaymentCardUiModel.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/3/7.
//

public struct CheckoutPaymentCardUiModel: PickerViewModel {
    
    public enum Other {
        case taishin
        case union
        case linePay
    }
    
    public var _id: String { String(id) }
    public var _title: String {
        if let bankId = bankId {
            return "\(bankId) \(bank)"
        } else {
            return bank
        }
    }
    
    public let id: Int
    public let bankId: String?
    public var bank: String
    public var other: Other?
    public var number: String?
    public var isInstallment: Bool = false
    public var amount: Int = 0
    
    public static func mock() -> [CheckoutPaymentCardUiModel] {
        let list = [
            CheckoutPaymentCardUiModel(id: 2, bankId: "004", bank: "臺灣銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "005", bank: "臺灣土地銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "006", bank: "合作金庫商業銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "007", bank: "第一商業銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "008", bank: "華南商業銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "009", bank: "彰化商業銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "011", bank: "上海商業儲蓄銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "012", bank: "台北富邦商業銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "013", bank: "國泰世華商業銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "822", bank: "中國信託商業銀行", other: .union),
            CheckoutPaymentCardUiModel(id: 2, bankId: "700", bank: "中華郵政", other: .union),
        ]
        return list
    }
}
