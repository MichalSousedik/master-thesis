//
//  EmployeeCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
import SFSafeSymbols
import RxSwift

class EmployeesCoordinator: BaseCoordinator {

    private let bag = DisposeBag()

    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = EmployeesViewController.instantiate()
        let service = UserService.shared
        view.viewModelBuilder = {
            return EmployeesViewModel(input: $0, api: service)
        }
        view.tabBarItem = UITabBarItem(title: L10n.myTeam, image: UIImage(systemSymbol: .person3Fill), tag: 0)
        view.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
        navigationController.pushViewController(view, animated: true)
        navigationController.navigationBar.prefersLargeTitles = true
    }

}
