//
//  CheckoutPaymentInstallmentUiModel.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/4/18.
//

public struct CheckoutPaymentInstallmentUiModel: PickerViewModel {
    public var _id: String { String(id) }
    public var _title: String { title }
    
    public let id: Int
    public let title: String
    public var installment: Bool = false
}
