//
//  HourRateStatsCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 20/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
import SFSafeSymbols

class HourRateStatsCoordinator: BaseCoordinator {

    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = HourRateStatsViewController.instantiate()
        view.viewModelBuilder = {
            HourRateStatsViewModel(input: $0,
                                   dependencies: (
                                    userAPI: UserService.shared,
                                    hourRateAPI: HourRateService.shared))
        }
        view.tabBarItem = UITabBarItem(title: L10n.hourRateStatistics, image: Asset.Images.hourRate.image, tag: 0)
        navigationController.pushViewController(view, animated: true)
        setupNavigationBar()
    }

    func setupNavigationBar(){
        navigationController.navigationBar.prefersLargeTitles = false
    }

}
