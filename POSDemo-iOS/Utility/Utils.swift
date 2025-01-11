//
//  Utils.swift
//  BlablaBlock
//
//  Created by Harry on 2021/11/13.
//

import UIKit

public class Utils {
    static func topMostViewController() -> UIViewController? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController?
            .topMostViewController()
    }
}
