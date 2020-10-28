//
//  WageCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit

class WageCoordinator: BaseCoordinator {
    
    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }
    
    override func start(){
        let view = WageViewController.instantiate()
        view.tabBarItem = UITabBarItem(title: "Mzda", image: UIImage(systemName: "dollarsign.square.fill"), tag: 0)
        navigationController.pushViewController(view, animated: true)
    }
    
}
