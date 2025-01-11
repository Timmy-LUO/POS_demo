//
//  Coordinator.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2024/11/14.
//

import UIKit

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var rootViewController: UIViewController? { get set }
    var navigationController: UINavigationController? { get set }

    func start()
}
