//
//  AlertDialogViewController.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/2/11.
//

import UIKit
import SnapKit

public final class AlertDialogViewController: UIViewController {
    
    private var alertTitle: String!
    private var showLeftButton: Bool = false
    private var showRightButton: Bool = true
    private var leftButtonTitle: String?
    private var onLeftButtonClick: (() -> Void)?
    private var rightButtonTitle: String?
    private var onRightButtonClick: (() -> Void)?
    private var onDismissed: (() -> Void)?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    public func hideButtons() {
        leftButton.isHidden = true
        rightButton.isHidden = true
    }
    
    public func showLeftButton(callback: @escaping () -> Void) {
        onLeftButtonClick = callback
        leftButton.isHidden = false
    }
    
    public func showRightButton(callback: @escaping () -> Void) {
        onRightButtonClick = callback
        rightButton.isHidden = false
    }
    
    private func setupUI() {
        view.backgroundColor = "bg_blur_grey".color
        containerView.backgroundColor = .white
        
        titleLabel.setBlack(text: alertTitle, size: 26)
        titleLabel.numberOfLines = 15
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .center
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 36
        
        leftButton.isHidden = !showLeftButton
        leftButton.setTitle(leftButtonTitle ?? "取消", for: .normal)
        leftButton.addTarget(self, action: #selector(onLeftButtonClicked), for: .touchUpInside)
        
        rightButton.isHidden = !showRightButton
        rightButton.setTitle(rightButtonTitle ?? "確認", for: .normal)
        rightButton.addTarget(self, action: #selector(onRightButtonClicked), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(containerView) { make in
            make.width.greaterThanOrEqualTo(470)
            make.height.greaterThanOrEqualTo(280)
            make.center.equalToSuperview()
        }
        containerView.addSubview(titleLabel) { make in
            make.width.lessThanOrEqualTo(800)
            make.leading.equalToSuperview().offset(36)
            make.top.equalToSuperview().offset(68)
            make.trailing.equalToSuperview().offset(-36)
        }
        
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(95)
            make.height.equalTo(40)
        }
        buttonStackView.addArrangedSubview(leftButton)
        
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(95)
            make.height.equalTo(40)
        }
        buttonStackView.addArrangedSubview(rightButton)
        
        containerView.addSubview(buttonStackView) { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.bottom.equalToSuperview().offset(-68)
        }
    }
    
    @objc
    private func onLeftButtonClicked() {
        dismiss(animated: true, completion: onLeftButtonClick)
    }
    
    @objc
    private func onRightButtonClicked() {
        dismiss(animated: true, completion: onRightButtonClick)
    }
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let leftButton = HollowButton()
    private let rightButton = SolidButton()
    
    public class Builder {
        
        private var alertTitle: String!
        private var showLeftButton = false
        private var hideButton = false
        private var leftButtonTitle: String?
        private var onLeftButtonClick: (() -> Void)?
        private var rightButtonTitle: String?
        private var onRightButtonClick: (() -> Void)?
        private var onDismissed: (() -> Void)?
        
        public func setTitle(_ title: String) -> Self {
            self.alertTitle = title
            return self
        }
        
        public func setLeftButton(title: String? = nil, onClick: (() -> Void)?) -> Self {
            self.showLeftButton = true
            self.leftButtonTitle = title
            self.onLeftButtonClick = onClick
            return self
        }
        
        public func setRightButton(title: String? = nil, onClick: (() -> Void)?) -> Self {
            self.rightButtonTitle = title
            self.onRightButtonClick = onClick
            return self
        }
        
        public func setNoButton() -> Self {
            self.hideButton = true
            return self
        }
        
        public func setOnDismissed(_ onDismissed: @escaping () -> Void) -> Self {
            self.onDismissed = onDismissed
            return self
        }
        
        public func build() -> AlertDialogViewController {
            let vc = AlertDialogViewController()
            vc.alertTitle = alertTitle
            
            vc.showLeftButton = showLeftButton
            vc.leftButtonTitle = leftButtonTitle
            vc.onLeftButtonClick = onLeftButtonClick
            
            vc.showRightButton = !hideButton
            vc.rightButtonTitle = rightButtonTitle
            vc.onRightButtonClick = onRightButtonClick
            
            vc.onDismissed = onDismissed
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            return vc
        }
        
        @discardableResult
        public func show(parent: UIViewController? = nil) -> AlertDialogViewController {
            let vc = build()
            (parent ?? Utils.topMostViewController())?.present(vc, animated: true)
            return vc
        }
    }
}
