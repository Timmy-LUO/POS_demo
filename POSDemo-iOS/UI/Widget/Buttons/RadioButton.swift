//
//  RadioButton.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/1/28.
//

import UIKit

public protocol RadioButtonDelegate {
    func onClicked(radioButton: RadioButton)
}

final public class RadioButton: UIButton {
    
    public var delegate: RadioButtonDelegate?
    override public var buttonType: UIButton.ButtonType { .custom }
    private var _borderWidth: CGFloat = 1

    override public var isSelected: Bool {
        didSet { setIsSelected() }
    }
    
    convenience init(borderWidth: CGFloat) {
        self.init(frame: .zero)
        self._borderWidth = borderWidth
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 2
        layer.borderColor = "bg_pink".color.cgColor
        layer.borderWidth = _borderWidth
        
        titleLabel?.font = .systemFont(ofSize: 18)
        setTitleColor("text_pink".color, for: .normal)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isSelected = !isSelected
        delegate?.onClicked(radioButton: self)
    }
    
    private func setIsSelected() {
        if isSelected {
            layer.borderWidth = 0
            backgroundColor = "bg_pink".color
            setTitleColor(.white, for: .normal)
        } else {
            layer.borderWidth = _borderWidth
            backgroundColor = .white
            setTitleColor("text_pink".color, for: .normal)
        }
    }
}
