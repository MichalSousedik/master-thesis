//
//  AdminTabBarController.swift
//  Milacci
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//
import UIKit

class AdminTabBarControoler: BaseTabBarController {
    override var coordinators: [Coordinator] {[
        EmployeesCoordinator(navigationController: BaseNavigationController()),
        UserProfileCoordinator(userIdProvider: { () in
            UserSettingsService.shared.userId
        }, navigationController: UINavigationController())
    ]}
}
