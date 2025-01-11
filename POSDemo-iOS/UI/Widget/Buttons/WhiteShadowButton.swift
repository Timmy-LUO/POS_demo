//
//  WhiteShadowButton.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/2/11.
//

import UIKit

final public class WhiteShadowButton: UIButton {
    
    convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        titleLabel?.font = .systemFont(ofSize: 20)
        setTitle("返回", for: .normal)
        setTitleColor("text_pink".color, for: .normal)
    }
}
