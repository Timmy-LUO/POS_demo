//
//  POSDemoInputView.swift
//  POSDemoInputView
//
//  Created by ZHI on 2023/2/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class POSDemoInputView: UIView {
    
    private var title: String!
    private var titleWidth: CGFloat!
    private var textFieldWidth: CGFloat!
    private var contentMax: Int!
    
    public var contentRelay = BehaviorRelay<String?>(value: nil)
    private var bag = DisposeBag()
    
    public var content: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }
    
    public var isEmptyObservable: Observable<Bool> {
        textField.isEmptyObservable
    }
    
    
    convenience init(title: String, titleWidth: CGFloat, textFieldWidth: CGFloat? = nil, contentMax: Int? = nil) {
        self.init(frame: .zero)
        self.title = title
        self.titleWidth = titleWidth
        self.textFieldWidth = textFieldWidth
        self.contentMax = contentMax
        commonInit()
    }
    
    public func setContent(_ content: String) {
        textField.text = content
        textField.sendActions(for: .valueChanged)
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        titleLabel.setPink20(text: title)
        if let max = contentMax {
            textField.max = max
        }
    }
    
    private func setupLayout() {
        textField.rx
            .text
            .bind(to: contentRelay)
            .disposed(by: bag)
        
        self.addSubview(textField) { make in
            if let contentWidth = textFieldWidth {
                make.width.equalTo(contentWidth)
            }
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self.addSubview(titleLabel) { make in
            make.width.equalTo(titleWidth)
            make.leading.equalToSuperview()
            make.centerY.equalTo(textField)
            make.trailing.equalTo(textField.snp.leading)
        }
    }
    
    private let titleLabel = UILabel()
    private let textField = POSDemoTextField()
}
