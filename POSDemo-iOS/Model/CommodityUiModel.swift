//
//  CommodityUiModel.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/1/22.
//

public struct CommodityUiModel: Hashable {
    public let id: Int
    public let sn: String
    public let name: String
    public let imageUrl: String?
    public let labelNameList: [String]
    public let colorList: [CommodityColorUiModel]
    public let sizeList: [CommoditySizeUiModel]
    public let price: Int
    public let inventory: Int
    
    public func toCheckoutModel(
        color: CommodityColorUiModel,
        size: CommoditySizeUiModel
    ) -> CheckoutCommodityUiModel {
        CheckoutCommodityUiModel(
            id: id,
            sn: sn,
            name: name,
            color: color,
            size: size,
            price: price,
            inventory: inventory,
            count: 1
        )
    }
    
    public static func commodityLabelMock() -> [String] {
        let list = ["種類1", "種類2", "種類3", "種類4", "種類5", "種類6"]
        return list
    }
    
    public static func generateMockCommodities(count: Int) -> [CommodityUiModel] {
        var commodities = [CommodityUiModel]()
        
        for i in 1...count {
            let commodity = CommodityUiModel(
                id: i,
                sn: "SN\(1000 + i)",
                name: "商品名稱 \(i)",
                imageUrl: nil,
                labelNameList: commodityLabelMock().shuffled().prefix(Int.random(in: 1...3)).map { $0 },
                colorList: generateMockColors(count: Int.random(in: 1...5)),
                sizeList: generateMockSizes(count: Int.random(in: 1...5)),
                price: (200 + i) * i,
                inventory: (1000 + i) * i
            )
            commodities.append(commodity)
        }
        
        return commodities
    }

    public static func generateMockColors(count: Int) -> [CommodityColorUiModel] {
        var colors = [CommodityColorUiModel]()
        let colorOptions = [
            ("#FF0000", "紅色"),
            ("#00FF00", "綠色"),
            ("#0000FF", "藍色"),
            ("#FFFF00", "黃色"),
            ("#FF00FF", "紫色")
        ]
        
        for i in 0..<count {
            let color = colorOptions[i % colorOptions.count]
            colors.append(CommodityColorUiModel(
                code: color.0,
                name: color.1,
                isSelected: Bool.random()
            ))
        }
        
        return colors
    }

    public static func generateMockSizes(count: Int) -> [CommoditySizeUiModel] {
        var sizes = [CommoditySizeUiModel]()
        let sizeOptions = [
            ("S", "小"),
            ("M", "中"),
            ("L", "大"),
            ("XL", "加大"),
            ("XXL", "超大")
        ]
        
        for i in 0..<count {
            let size = sizeOptions[i % sizeOptions.count]
            sizes.append(CommoditySizeUiModel(
                code: size.0,
                name: size.1,
                isSelected: Bool.random()
            ))
        }
        
        return sizes
    }
}

public struct CommodityColorUiModel: Hashable {
    public let code: String
    public let name: String
    public var isSelected: Bool = false
}

public struct CommoditySizeUiModel: Hashable {
    public let code: String
    public let name: String
    public var isSelected: Bool = false
}
