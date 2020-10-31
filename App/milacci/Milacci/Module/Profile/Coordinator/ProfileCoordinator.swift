//
//  ProfileCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
import SFSafeSymbols

class ProfileCoordinator: BaseCoordinator {

    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = ProfileViewController.instantiate()
        view.tabBarItem = UITabBarItem(title: L10n.profile, image: UIImage(systemSymbol: .personFill), tag: 0)
        view.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
        navigationController.pushViewController(view, animated: true)
    }

}
