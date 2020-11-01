//
//  InitiatingCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 01/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

class InitiatingCoordinator: BaseCoordinator {

    var vc: InitiatingViewController?

    override func start(){
        self.vc = InitiatingViewController.instantiate()
    }

}
