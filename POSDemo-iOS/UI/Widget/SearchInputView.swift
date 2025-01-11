//
//  SearchInputView.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/3/4.
//

import UIKit
import SnapKit
import RxCocoa

public final class SearchInputView: UIView {
    
    public var contentRelay: ControlProperty<String> {
        textField.rx
            .text
            .orEmpty
    }
    
    public convenience init() {
        self.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 7
        self.backgroundColor = "commodity_view_search_section_bg".color
        imageView.image = "ic_commodity_search".image
    }
    
    private func setupLayout() {
        addSubview(imageView) { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
        }
        addSubview(textField) { make in
            make.leading.equalTo(imageView.snp.trailing).offset(6)
            make.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private let imageView = UIImageView()
    private let textField = UITextField()
}
