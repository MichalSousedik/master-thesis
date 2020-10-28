    //
//  AppCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class AppCoordinator: BaseCoordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    func reload() {
        if let signInModel = UserSettingsService.shared.getSignInModel() {
            window.rootViewController = TabBarControllerFactory.create(roles: signInModel.user.roles ?? [])
        } else {
            let signInCoordinator = SignInCoordinator()
            self.add(coordinator: signInCoordinator)
            signInCoordinator.start()
            window.rootViewController = signInCoordinator.navigationController
        }
        window.makeKeyAndVisible()
    }

}
