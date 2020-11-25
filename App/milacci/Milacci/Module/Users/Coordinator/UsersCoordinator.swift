//
//  EmployeeCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift

class UsersCoordinator: BaseCoordinator {

    let bag = DisposeBag()
    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let viewController = UsersViewControllerFactory.create(viewModelBuilder: provideViewModelBuilder(), title: provideTitle(), searchFieldText: provideSearchFieldText())
        navigationController.pushViewController(viewController, animated: true)
        navigationController.navigationBar.prefersLargeTitles = true
    }

    func provideViewModelBuilder() -> ((UsersViewPresentable.Input) -> UsersViewPresentable) {
            fatalError("Not implemented")
    }

    func provideTitle() -> String {
        fatalError("Not implemented")
    }

    func provideSearchFieldText() -> String {
        fatalError("Not implemented")
    }

    func provideEmployeeProfileCoordinator(userDetail: UserDetail, navigationController: UINavigationController) -> EmployeeProfileCoordinator {
        fatalError("Not implemented")
    }

    func showDetail(usingModel model: UserDetail){
        let employeeProfileCoordinator = self.provideEmployeeProfileCoordinator(userDetail: model, navigationController: navigationController)
        self.add(coordinator: employeeProfileCoordinator)
        employeeProfileCoordinator.start()
    }

}
