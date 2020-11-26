//
//  InvoicesCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 21/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class InvoicesCoordinator: BaseCoordinator {

    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let vc = InvoicesViewController.instantiate()
        vc.actionViewModelBuilder = {
            InvoiceActionViewModel(input: $0, api: InvoiceService.shared)
        }
        vc.viewModelBuilder = {
            InvoicesViewModel(input: $0,
                              api: InvoiceService.shared)
        }
        vc.tabBarItem = UITabBarItem(title: L10n.invoices, image: Asset.Images.invoiceMinimalistIcon.image, tag: 0)
        navigationController.pushViewController(vc, animated: true)
        navigationController.navigationBar.prefersLargeTitles = true
    }

}
