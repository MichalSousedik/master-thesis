//
//  WorkerTabBarController.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit

class WorkerTabBarControoler: BaseTabBarController {
    override var coordinators: [Coordinator] {[
        InvoicesCoordinator(navigationController: BaseNavigationController()),
        WageCoordinator(navigationController: BaseNavigationController()),
        UserProfileCoordinator(userIdProvider: { () in
            UserSettingsService.shared.userId
        }, navigationController: UINavigationController())
    ]}
}
