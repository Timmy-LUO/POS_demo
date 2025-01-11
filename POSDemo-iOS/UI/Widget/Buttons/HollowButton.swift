//
//  HollowButton.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/1/27.
//

import UIKit

final public class HollowButton: UIButton {
    
    convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 2
        layer.borderColor = "bg_pink".color.cgColor
        layer.borderWidth = 2
        
        titleLabel?.font = .systemFont(ofSize: 18)
        setTitleColor("text_pink".color, for: .normal)
    }
}
