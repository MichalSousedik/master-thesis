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
            showInitiatingViewController()
            window.makeKeyAndVisible()
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        }

        func reload() {
            var vc: UIViewController?
            if let signInModel = UserSettingsService.shared.getSignInModel() {
                vc = TabBarControllerFactory.create(roles: signInModel.user.roles ?? [])
            } else {
                vc = showSignIn()
            }
            displayViewController(vc: vc)
        }

        private func showInitiatingViewController() {
            let coordinator = InitiatingCoordinator(window: window)
            self.addChild(coordinator: coordinator)
            coordinator.start()
        }

        private func showSignIn() -> UIViewController? {
            let signInCoordinator = SignInCoordinator()
            self.addChild(coordinator: signInCoordinator)
            signInCoordinator.start()
            return signInCoordinator.vc
        }

        private func displayViewController(vc: UIViewController?) {
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }

    }
