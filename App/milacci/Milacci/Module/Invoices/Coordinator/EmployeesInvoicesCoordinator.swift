//
//  EmployeesInvoicesCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 23/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class EmployeesInvoicesCoordinator: BaseCoordinator {

    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let vc = EmployeesInvoicesViewController.instantiate()
        vc.actionViewModelBuilder = {
            InvoiceActionViewModel(input: $0, api: InvoiceService.shared)
        }
        vc.viewModelBuilder = {
            EmployeesInvoicesViewModel(input: $0,
                                       api: InvoiceService.shared)
        }
        vc.tabBarItem = UITabBarItem(title: L10n.employeesInvoices, image: Asset.Images.invoicesIcon.image, tag: 0)
        navigationController.pushViewController(vc, animated: true)
        navigationController.navigationBar.prefersLargeTitles = false
    }

}
