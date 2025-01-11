//
//  InfoView.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2023/2/12.
//

import UIKit
import SnapKit

final public class InfoView: UIView {
    
    private var title: String!
    private var titleWidth: CGFloat!
    private var spacing: CGFloat!
    private var contentWidth: CGFloat!
    private var scrollable = false
    
    public var content: String {
        get { contentLabel.text ?? "" }
        set { contentLabel.text = newValue }
    }
    
    public func set(title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
    
    convenience init(
        title: String? = nil,
        titleWidth: CGFloat? = nil,
        spacing: CGFloat? = nil,
        contentWidth: CGFloat? = nil,
        scrollable: Bool = false
    ) {
        self.init(frame: .zero)
        self.title = title
        self.titleWidth = titleWidth
        self.spacing = spacing
        self.contentWidth = contentWidth
        self.scrollable = scrollable
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        titleLabel.setPink20(text: title)
        contentLabel.setBlack20()
        contentLabel.numberOfLines = 0
        if scrollable {
            contentScrollView = UIScrollView()
            contentScrollView.alwaysBounceVertical = false
            contentScrollView.showsHorizontalScrollIndicator = false
            contentScrollView.showsVerticalScrollIndicator = false
        }
        #if DEBUG
        contentLabel.text = "CONTENT"
        #endif
    }
    
    private func setupLayout() {
        self.addSubview(titleLabel) { make in
            if let width = titleWidth {
                make.width.equalTo(width)
            }
            make.top.leading.bottom.equalToSuperview()
        }
        
        if scrollable {
            self.addSubview(contentScrollView) { make in
                if let contentWidth = contentWidth {
                    make.width.equalTo(contentWidth)
                }
                if let spacing = spacing {
                    make.leading.equalTo(titleLabel.snp.trailing).offset(spacing)
                } else {
                    make.leading.equalTo(titleLabel.snp.trailing)
                }
                make.trailing.equalToSuperview()
                make.centerY.equalTo(titleLabel)
            }
            
            contentScrollView.addSubview(contentLabel) { make in
                make.height.equalToSuperview()
                make.edges.equalToSuperview()
            }
        } else {
            self.addSubview(contentLabel) { make in
                if let contentWidth = contentWidth {
                    make.width.equalTo(contentWidth)
                }
                if let spacing = spacing {
                    make.leading.equalTo(titleLabel.snp.trailing).offset(spacing)
                } else {
                    make.leading.equalTo(titleLabel.snp.trailing)
                }
                make.trailing.equalToSuperview()
                make.centerY.equalTo(titleLabel)
                make.top.bottom.equalToSuperview()
            }
        }
    }
    
    private let titleLabel = UILabel()
    private var contentScrollView: UIScrollView!
    private let contentLabel = UILabel()
}
