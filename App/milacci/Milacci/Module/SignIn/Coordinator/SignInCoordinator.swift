//
//  GoogleSignInCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit

class SignInCoordinator: BaseCoordinator {

    var vc: SignInViewController?

    override func start(){
        self.vc = SignInViewController.instantiate()
    }

}
