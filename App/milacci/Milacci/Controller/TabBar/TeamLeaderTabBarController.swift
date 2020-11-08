//
//  TeamLeaderTabBarController.swift
//  Milacci
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class TeamLeaderTabBarController: BaseTabBarController {
    override var coordinators: [Coordinator] {[

        InvoicesCoordinator(navigationController: BaseNavigationController()),
        WageCoordinator(userIdProvider: { () in
            UserSettingsService.shared.userId
        }, navigationController: UINavigationController()),
        UserProfileCoordinator(userIdProvider: { () in
            UserSettingsService.shared.userId
        }, navigationController: UINavigationController())
    ]}
}
