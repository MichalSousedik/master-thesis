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

class UserProfileCoordinator: BaseCoordinator {

    private let userIdProvider: UserProfileViewPresentable.UserIdProvider

    init(userIdProvider: @escaping UserProfileViewPresentable.UserIdProvider, navigationController: UINavigationController) {
        self.userIdProvider = userIdProvider
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = UserProfileViewController.instantiate()
    view.viewModelBuilder = { [userIdProvider] in
            return UserProfileViewModel(input: $0,
                                        dependencies: (
                                            api: UserService.shared,
                                            userIdProvider: userIdProvider))
        }
        view.tabBarItem = UITabBarItem(title: L10n.profile, image: UIImage(systemSymbol: .personFill), tag: 0)
        view.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
        navigationController.pushViewController(view, animated: true)
        self.setupNavigationBar()
    }

    func setupNavigationBar(){
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .none
        navigationBarAppearence.backgroundColor = Asset.Colors.primary.color
        navigationController.navigationBar.standardAppearance = navigationBarAppearence

    }

}
