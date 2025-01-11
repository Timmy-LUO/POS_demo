//
//  BaseViewController.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

open class BaseViewController: UIViewController {
    
    internal let disposeBag = DisposeBag()

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(safeEdgesView) { make in
            make.edges.equalTo(view.safeAreaEdges)
        }
    }
    
//    open override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        shortLifecycleOwner = DisposeBag()
//    }
//    
//    open override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        shortLifecycleOwner = nil
//    }
//    
//    internal func bindErrorHandler(_ viewModel: BaseViewModelOutputs) {
//        viewModel.errorMessage
//            .emit(onNext: { [weak self] statusCode, msg in
//                if let code = statusCode, code == 401 || code == 403 {
//                    self?.loginAgainAlert(message: msg) { [weak self] in
//                        self?.navigationController?.popToRoot()
//                    }
//                } else {
//                    self?.promptAlert(message: msg)
//                }
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    internal func promptAlert(error: Error, action: (() -> Void)? = nil) {
//        promptAlert(message: "\(error)", action: action)
//    }
//    
//    internal func promptAlert(message: String, action: (() -> Void)? = nil) {
//        AlertBuilder()
//            .setMessage(message)
//            .setOkButton(action: action)
//            .show(self)
//    }
//    
//    internal func loginAgainAlert(message: String, action: (() -> Void)? = nil) {
//        AlertBuilder()
//            .setMessage(message)
//            .setOkButton(action: action)
//            .show(self)
//    }
    
    internal let safeEdgesView = UIView()
}
