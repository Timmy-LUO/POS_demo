//
//  BaseTitleDialogViewController.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/2/11.
//

import UIKit
import SnapKit

open class BaseTitleDialogViewController: BaseViewController {
    
    internal var showBottomButton = true
    internal var showChangePageView = false
    internal var basePage: Int = 1
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    internal func setupUI() {
        view.backgroundColor = "bg_blur_grey".color
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 2
        titleLabel.text = "TITLE"
        titleLabel.font = .systemFont(ofSize: 22)
        titleLabel.textColor = "text_black".color
        closeButton.setImage("ic_close".image, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        separator.backgroundColor = "separator_pink".color
        bottomButton.setTitle("確認", for: .normal)
        bottomButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        changePageStackView.axis = .horizontal
        changePageStackView.distribution = .fillEqually
        changePageStackView.spacing = 20
        
        leftButton.setTitle("<", for: .normal)
        leftButton.setTitleColor(.black, for: .normal)
        leftButton.addTarget(self, action: #selector(leftOnClick), for: .touchUpInside)
        
        pageLabel.text = "\(basePage)"
        pageLabel.textAlignment = .center
        pageLabel.font = .systemFont(ofSize: 20)
        
        rightButton.setTitle(">", for: .normal)
        rightButton.setTitleColor(.black, for: .normal)
        rightButton.addTarget(self, action: #selector(rightOnClick), for: .touchUpInside)
    }
    
    @objc
    internal func close() {
        dismiss(animated: true)
    }
    
    @objc
    internal func leftOnClick() {}
    
    @objc
    internal func rightOnClick() {}
    
    @objc
    internal func onClick() {}
    
    internal func setupLayout() {
        view.addSubview(backgroundView) { make in
            make.center.equalToSuperview()
        }
        
        backgroundView.addSubview(titleLabel) { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        
        backgroundView.addSubview(closeButton) { make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        backgroundView.addSubview(separator) { make in
            make.height.equalTo(2)
            make.leading.equalToSuperview().offset(82)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-82)
        }
        
        if showBottomButton {
            backgroundView.addSubview(bottomButton) { make in
                make.width.equalTo(95)
                make.height.equalTo(40)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-36)
            }
            
            backgroundView.addSubview(containerView) { make in
                make.leading.trailing.equalTo(separator)
                make.top.equalTo(separator.snp.bottom)
                make.bottom.equalTo(bottomButton.snp.top).offset(-10)
            }
        } else {
            backgroundView.addSubview(containerView) { make in
                make.leading.trailing.equalTo(separator)
                make.top.equalTo(separator.snp.bottom)
                make.bottom.equalToSuperview()
            }
        }
        
        if showChangePageView {
            backgroundView.addSubview(changePageStackView) { make in
                make.centerY.equalTo(bottomButton)
                make.leading.equalTo(separator.snp.leading)
            }
            changePageStackView.addArrangedSubview(leftButton)
            changePageStackView.addArrangedSubview(pageLabel)
            changePageStackView.addArrangedSubview(rightButton)
            
            leftButton.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
            rightButton.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
        }
    }
    
    internal let backgroundView = UIView()
    internal let titleLabel = UILabel()
    internal let closeButton = UIButton()
    internal let separator = UIView()
    internal let containerView = UIView()
    internal let changePageStackView = UIStackView()
    internal let leftButton = UIButton()
    internal let pageLabel = UILabel()
    internal let rightButton = UIButton()
    internal let bottomButton = SolidButton()
}
