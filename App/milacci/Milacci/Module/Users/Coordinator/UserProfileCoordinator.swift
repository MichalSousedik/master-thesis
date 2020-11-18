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

class UserProfileCoordinator: ProfileCoordinator {

    override init(userIdProvider: @escaping UserProfileViewPresentable.UserIdProvider, navigationController: UINavigationController) {
        super.init(userIdProvider: userIdProvider, navigationController: navigationController)
    }

    override func setupTabBar(vc: UIViewController) {

        vc.tabBarItem = UITabBarItem(title: L10n.profile, image: UIImage(systemSymbol: .personFill), tag: 0)
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
    }

    override func createViewController() -> ProfileViewController {
        return UserProfileViewController()
    }

    override func provideViewModelBuilder() -> UserProfileViewPresentable.ViewModelBuilder {
        { [userIdProvider] (input, editInput) in
            return UserProfileViewModel(input: input,
                                        dependencies: (
                                            api: UserService.shared,
                                            userIdProvider: userIdProvider,
                                            userDetail: nil
                                        ))
        }
    }
}

