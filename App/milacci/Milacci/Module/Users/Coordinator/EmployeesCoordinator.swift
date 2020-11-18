//
//  AdminEmployeesCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 13/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class EmployeesCoordinator: UsersCoordinator {

    override func provideViewModelBuilder() -> ((UsersViewPresentable.Input) -> UsersViewPresentable) {
        { [bag] in
            let providedViewModel = EmployeesViewModel(input: $0, api: UserService.shared)
            providedViewModel.routing.map { [weak self] (userDetail) in
                self?.showDetail(usingModel: userDetail)
            }
            .drive()
            .disposed(by: bag)
            return providedViewModel
        }
    }

    override func provideTitle() -> String {
        return L10n.employees
    }

    override func provideSearchFieldText() -> String {
        return L10n.findEmployee
    }

    override func provideEmployeeProfileCoordinator(userDetail: UserDetail, navigationController: UINavigationController) -> EmployeeProfileCoordinator {
        return EditableEmployeeProfileCoordinator(userDetail: userDetail, navigationController: navigationController)
    }
}
