//
//  POSDemoTitleInputDialogViewController.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/2/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

public final class POSDemoTitleInputDialogViewController: BaseTitleDialogViewController {
    
    private var titleString: String!
    private var desc: String!
    private var inputTitle: String!
    private var inputTitleWidth: CGFloat!
    private var textFieldWidth: CGFloat?
    private var buttonTitle: String!
    
//    private var memberUbnTitle: String?
//    private var showMemberUbnButton: Bool = false
    
    private var onResult: ((String) -> Void)!
    
    override internal func onClick() {
        let content = contentInputView.content
        dismiss(animated: true) { [weak self] in
            self?.onResult?(content)
        }
    }
    
    override internal func setupUI() {
        super.setupUI()
        showBottomButton = true
        titleLabel.text = titleString
        descLabel.setPink20(text: desc)
        
//        ubnButton.isHidden = !showMemberUbnButton
//        if memberUbnTitle != "" {
//            ubnButton.setTitle(memberUbnTitle ?? "")
//            ubnButton.setOnClick { [weak self] in
//                guard let self = self else { return }
//                self.contentInputView.content = self.memberUbnTitle ?? ""
//            }
//        } else {
//            ubnButton.isHidden = true
//        }
    }
    
    override internal func setupLayout() {
        super.setupLayout()
        containerView.addSubview(descLabel) { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        containerView.addSubview(contentInputView) { make in
            make.top.equalTo(descLabel.snp.bottom).offset(32)
            make.bottom.equalToSuperview().offset(-95)
            make.centerX.equalToSuperview()
        }
        
//        containerView.addSubview(ubnButton) { make in
//            make.width.equalTo(105)
//            make.height.equalTo(35)
//            make.centerX.equalToSuperview()
//            make.top.equalTo(contentInputView.snp.bottom).offset(20)
//        }
        
        backgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(186)
            make.trailing.equalToSuperview().offset(-186)
        }
    }
    
    private let descLabel = UILabel()
    private lazy var contentInputView = POSDemoInputView(
        title: inputTitle ?? "",
        titleWidth: inputTitleWidth ?? 0,
        textFieldWidth: textFieldWidth
    )
//    private let ubnButton = FunctionButton(font: .systemFont(ofSize: 18), shadowOffset: CGSize(width: 0, height: 3))
    
    public final class Builder {
        private var titleString: String!
        private var desc: String!
        private var inputTitle: String!
        private var inputTitleWidth: CGFloat!
        private var textFieldWidth: CGFloat?
        private var buttonTitle: String!
        
        private var showMemberUbnButton: Bool = false
        private var memberUbnTitle: String?
        
        private var onResult: ((String) -> Void)!
        
        public func setTitle(_ text: String) -> Self {
            titleString = text
            return self
        }
        
        public func setDesc(_ text: String) -> Self {
            desc = text
            return self
        }
        
        public func setInputTitle(_ text: String) -> Self {
            inputTitle = text
            return self
        }
        
        public func setTitleWidth(_ width: CGFloat) -> Self {
            inputTitleWidth = width
            return self
        }
        
        public func setTextFieldWidth(_ width: CGFloat) -> Self {
            textFieldWidth = width
            return self
        }
        
        public func setButton(_ title: String, onResult: @escaping ((String) -> Void)) -> Self {
            buttonTitle = title
            self.onResult = onResult
            return self
        }
        
        public func setUbnButton(title: String? = nil) -> Self {
            self.showMemberUbnButton = true
            self.memberUbnTitle = title
            return self
        }
        
        public func build() -> POSDemoTitleInputDialogViewController {
            let vc = POSDemoTitleInputDialogViewController()
            vc.titleString = titleString
            vc.desc = desc
            vc.inputTitle = inputTitle
            vc.inputTitleWidth = inputTitleWidth
            vc.textFieldWidth = textFieldWidth
            vc.buttonTitle = buttonTitle
            
//            vc.showMemberUbnButton = showMemberUbnButton
//            vc.memberUbnTitle = memberUbnTitle
            
            vc.onResult = onResult
            return vc
        }
        
        public func show(parent: UIViewController? = nil) {
            let vc = build()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            (parent ?? Utils.topMostViewController())?.present(vc, animated: true)
        }
    }
}
