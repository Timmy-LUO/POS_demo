//
//  CommodityLabelUiModel.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2024/12/5.
//

//public struct CommodityLabelUiModel: Hashable {
//    public let title: String
//    public let subTitleList: [CommodityLabelUiModel]
//    public let isRooit: Bool
//    
//    public static func mock(count: Int, subTitleCount: Int) -> [CommodityLabelUiModel] {
//        var list = [CommodityLabelUiModel]()
//        for i in 1 ... count {
//            let title = "Commodity \(i)"
//            
//            var subTitles = [CommodityLabelUiModel]()
//            for j in 1 ... subTitleCount {
//                subTitles.append(
//                    CommodityLabelUiModel(
//                        title: "Commodity \(i) - SubTitle \(j)",
//                        subTitleList: [],
//                        isRooit: false
//                    )
//                )
//            }
//            
//            list.append(
//                CommodityLabelUiModel(
//                    title: title,
//                    subTitleList: subTitles,
//                    isRooit: true
//                )
//            )
//        }
//        
//        return list
//    }
//}
