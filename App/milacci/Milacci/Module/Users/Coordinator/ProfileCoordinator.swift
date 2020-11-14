//
//  ProfileCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 14/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
import SFSafeSymbols

class ProfileCoordinator: BaseCoordinator {

    typealias ModifyDetailViewController = ((UserProfileDetailViewController) -> Void)
    let userIdProvider: UserProfileViewPresentable.UserIdProvider

    init(userIdProvider: @escaping UserProfileViewPresentable.UserIdProvider, navigationController: UINavigationController) {
        self.userIdProvider = userIdProvider
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = createViewController()
        view.viewModelBuilder = self.provideViewModelBuilder()
        view.userProfileHeaderViewController = UserProfileHeaderViewController.instantiate()
        view.userProfileDetailViewController = UserProfileDetailViewController.instantiate()
        view.userProfileDetailViewController.modifyController = self.modifyDetailViewController()
        self.setupTabBar(vc: view)
        navigationController.pushViewController(view, animated: true)
        self.setupNavigationBar()
    }

    func setupNavigationBar(){
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .none
        navigationBarAppearence.backgroundColor = Asset.Colors.primary.color
        navigationController.navigationBar.standardAppearance = navigationBarAppearence
    }

    func setupTabBar(vc: UIViewController){
    }

    func provideViewModelBuilder() -> UserProfileViewPresentable.ViewModelBuilder {
        fatalError("Not implemented")
    }

    func modifyDetailViewController() -> ModifyDetailViewController {
        {_ in}
    }

    func createViewController() -> ProfileViewController {
        fatalError("Not implemented")
    }

}
