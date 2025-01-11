//
//  POSDemoTextField.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2022/2/27.
//

import UIKit

final public class POSDemoTextField: UITextField, UITextFieldDelegate {
    
    public var padding = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
    public var max: Int? = nil

    public convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        layer.cornerRadius = 2
        layer.borderWidth = 2
        layer.borderColor = "separator_grey_light".color.cgColor
        font = .systemFont(ofSize: 20)
        textColor = "text_black".color
        delegate = self
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: padding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let max = max {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= max
        } else {
            return true
        }
    }
}
