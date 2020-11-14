//
//  MyTeamCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 14/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class MyTeamCoordinator: UsersCoordinator {

    override func provideViewModelBuilder() -> ((UsersViewPresentable.Input) -> UsersViewPresentable) {
        { [bag] in
            let providedViewModel = MyTeamViewModel(input: $0, api: UserService.shared)
                providedViewModel.routing.map { [weak self] (userDetail) in
                self?.showDetail(usingModel: userDetail)
            }
            .drive()
            .disposed(by: bag)
            return providedViewModel
        }
    }

    override func provideTitle() -> String {
        return L10n.myTeam
    }

    override func provideSearchFieldText() -> String {
        return L10n.searchTeamMember
    }

    override func provideEmployeeProfileCoordinator(userDetail: UserDetail, navigationController: UINavigationController) -> EmployeeProfileCoordinator {
        return EmployeeProfileCoordinator(userDetail: userDetail, navigationController: navigationController)
    }
}
