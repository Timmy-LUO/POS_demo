//
//  WelcomeCoordinator.swift
//  POSDemo-iOS
//
//  Created by ZHI on 2024/11/14.
//

import UIKit

public final class WelcomeCoordinator: Coordinator {
    
    public var childCoordinators = [Coordinator]()
    public var rootViewController: UIViewController?
    public var navigationController: UINavigationController?
    
    public init() {
        let navigationController = UINavigationController()
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = CommodityViewController(self, viewModel: CommodityViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func toCheckoutReview(
        parentCoordinator: WelcomeCoordinator,
        isFirst: Bool = false,
        commodityViewModel: CommodityViewModelType
    ) {
        let vc = CheckoutReviewViewController(
            parentCoordinator,
            isFirst: isFirst,
            commodityViewModel: commodityViewModel,
            checkoutViewModel: CheckoutReviewViewModel()
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func toCheckoutPayment(viewModel: CheckoutPaymentViewModelType) {
        let vc = CheckoutPaymentViewController(self, viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
