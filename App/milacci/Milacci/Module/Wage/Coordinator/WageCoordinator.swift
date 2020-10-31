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

    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = WageViewController.instantiate()
        view.tabBarItem = UITabBarItem(title: L10n.wage, image: UIImage(systemSymbol: SFSymbol.dollarsignSquareFill), tag: 0)
        navigationController.pushViewController(view, animated: true)
    }

}
