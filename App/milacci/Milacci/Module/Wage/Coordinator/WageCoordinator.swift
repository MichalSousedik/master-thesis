//
//  WageCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
import SFSafeSymbols

class WageCoordinator: BaseCoordinator {

    private let userIdProvider: WageChartViewPresentable.UserIdProvider

    init(userIdProvider: @escaping UserProfileViewPresentable.UserIdProvider, navigationController: UINavigationController) {
        self.userIdProvider = userIdProvider
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = WageViewController.instantiate()
        self.setupHourlyRateViewController(view: view)
        self.setupChartViewController(view: view)
        view.tabBarItem = UITabBarItem(title: L10n.wage, image: Asset.Images.wageIcon.image, tag: 0)
        navigationController.pushViewController(view, animated: true)
        self.setupNavigationBar()
    }

    func setupHourlyRateViewController(view: WageViewController) {
        view.hourlyRateViewController = HourlyRateViewController.instantiate()
        view.hourlyRateViewController.viewModelBuilder = { [userIdProvider] in
            return HourlyRateViewModel(input: $0,
                                      dependencies: (
                                        api: UserService.shared,
                                        userIdProvider: userIdProvider))
        }
    }

    func setupChartViewController(view: WageViewController) {
        view.wageChartViewController = WageChartViewController.instantiate()
        view.wageChartViewController.viewModelBuilder = { [userIdProvider] in
            return WageChartViewModel(input: $0,
                                      dependencies: (
                                        api: InvoiceService.shared,
                                        userIdProvider: userIdProvider))
        }
    }

    func setupNavigationBar(){
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .none
        navigationBarAppearence.backgroundColor = Asset.Colors.primary.color
        navigationController.navigationBar.standardAppearance = navigationBarAppearence

    }

}
