//
//  EmployeeProfileCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 12/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit

class EmployeeProfileCoordinator: ProfileCoordinator {

    let userDetail: UserDetail

    init(userDetail: UserDetail, navigationController: UINavigationController) {
        self.userDetail = userDetail
        super.init(userIdProvider: {userDetail.id}, navigationController: navigationController)
    }

    override func modifyDetailViewController() -> ModifyDetailViewController {
        { (vc: UserProfileDetailViewController) in
            vc.hourlyRateStackView.isHidden = false
            vc.personalInfoHeaderStackView.isHidden = false

        }
    }

    override func createViewController() -> ProfileViewController {
        return EmployeeProfileViewController()
    }

    override func provideViewModelBuilder() -> UserProfileViewPresentable.ViewModelBuilder {
        { [userIdProvider, userDetail] (input, editInput) in
            return UserProfileViewModel(input: input,
                                        dependencies: (
                                            api: UserService.shared,
                                            userIdProvider: userIdProvider,
                                            userDetail: userDetail
                                        ))
        }
    }
}
