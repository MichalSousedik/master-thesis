//
//  InitiatingCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 01/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class InitiatingCoordinator: BaseCoordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start(){
        window.rootViewController = InitiatingViewController.instantiate()
        window.makeKeyAndVisible()
    }

}
