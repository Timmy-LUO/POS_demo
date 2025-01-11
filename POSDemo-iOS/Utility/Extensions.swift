//
//  Extensions.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2024/12/5.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

public extension String {
    var image: UIImage { UIImage(named: self)! }
    var color: UIColor { UIColor(named: self)! }
}

public extension UIView {
    var safeAreaEdges: ConstraintItem {
        safeAreaLayoutGuide.snp.edges
    }
    
    func addSubview(_ view: UIView, _ closure: (_ make: ConstraintMaker) -> Void) {
        addSubview(view)
        view.snp.makeConstraints(closure)
    }
}

public extension UILabel {
    func autoFontSize() {
        numberOfLines = 1
        adjustsFontSizeToFitWidth = true
    }
    
    func setPink20(text: String? = nil) {
        self.text = text
        font = .systemFont(ofSize: 20)
        textColor = "text_pink".color
    }
    
    func setBrown18(text: String? = nil) {
        self.text = text
        font = .systemFont(ofSize: 18)
        textColor = "text_brown".color
    }
    
    func setBlackLight18(text: String? = nil) {
        self.text = text
        font = .systemFont(ofSize: 18)
        textColor = "text_black_light".color
    }
    
    func setPink18(text: String? = nil) {
        self.text = text
        font = .systemFont(ofSize: 18)
        textColor = "text_pink".color
    }
    
    func setPink22(text: String? = nil) {
        self.text = text
        font = .systemFont(ofSize: 22)
        textColor = "text_pink".color
    }
    
    func setBlack18(text: String? = nil) {
        self.text = text
        font = .systemFont(ofSize: 18)
        textColor = "text_black".color
    }
    
    func setBlack20(text: String? = nil) {
        self.text = text
        font = .systemFont(ofSize: 20)
        textColor = "text_black".color
    }
    
    func setBlack(text: String? = nil, size: CGFloat) {
        self.text = text
        font = .systemFont(ofSize: size)
        textColor = "text_black".color
    }
}

public extension UITextField {
    var isEmptyObservable: Observable<Bool> {
        self.rx
            .text
            .orEmpty
            .map { !$0.isEmpty }
            .share(replay: 1)
    }
}

public extension Int {
    var formatted: String {
        withCommas()
    }
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

public extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        
        return self.presentedViewController!.topMostViewController()
    }
}

public extension UINavigationController {
    func popTo<T>(_ target: T.Type, animated: Bool = true, completion: ((T) -> Void)? = nil) {
        for viewController in viewControllers {
            if viewController is T {
                popToViewController(viewController, animated: animated)
                completion?(viewController as! T)
                return
            }
        }
    }
}
