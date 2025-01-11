//
//  SolidButton.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/1/27.
//

import UIKit

final public class SolidButton: UIButton {
    
    convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = "bg_pink".color
        layer.borderWidth = 1
        layer.borderColor = "bg_pink".color.cgColor
        layer.cornerRadius = 2
        layer.shadowColor = "bg_pink".color.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        titleLabel?.font = .systemFont(ofSize: 18)
        setTitleColor(.white, for: .normal)
    }
}
