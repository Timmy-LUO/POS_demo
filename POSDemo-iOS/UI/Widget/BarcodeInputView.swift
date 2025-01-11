//
//  BarcodeInputView.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2023/2/20.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

public final class BarcodeInputView: UIView {
    
    private var textFieldWidth: CGFloat?
    private var max: Int?
    private var bag = DisposeBag()
    
    public var contentRelay = BehaviorRelay<String?>(value: nil)
    
    public var isEmptyObservable: Observable<Bool> {
        textField.isEmptyObservable
    }
    
    public convenience init(textFieldWidth: CGFloat?, max: Int? = nil) {
        self.init(frame: .zero)
        self.textFieldWidth = textFieldWidth
        self.max = max
        commonInit()
    }
    
    public func setPlaceholder(_ placeholder: String) {
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: "separator_grey_light".color,
                .font: UIFont.systemFont(ofSize: 14.0),
                .paragraphStyle: centeredParagraphStyle
            ]
        )
    }
        
    public func clearText() {
        textField.text = ""
        contentRelay.accept("")
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        textField.max = max
        imageView.image = "ic_barcode_pink".image
    }
    
    private func setupLayout() {
        textField.rx
            .text
            .bind(to: contentRelay)
            .disposed(by: bag)
        
        self.addSubview(imageView) { make in
            make.width.height.equalTo(40)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        self.addSubview(textField) { make in
            if let width = textFieldWidth {
                make.width.equalTo(width)
            }
            make.height.equalTo(38)
            make.leading.centerY.equalToSuperview()
            make.trailing.equalTo(imageView.snp.leading).offset(-26)
        }
    }
    
    private let textField = POSDemoTextField()
    private let imageView = UIImageView()
}
