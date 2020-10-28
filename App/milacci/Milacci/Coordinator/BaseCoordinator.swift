//
//  BaseCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 21/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit

class BaseCoordinator: Coordinator {

    var navigationController: UINavigationController = UINavigationController()

    var childCoordinator: [Coordinator] = []

    func start() {
        fatalError("Start function is not implemented for BaseCoordinator class.")
    }

}
