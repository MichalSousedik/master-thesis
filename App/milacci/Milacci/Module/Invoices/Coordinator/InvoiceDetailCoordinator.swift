//
//  InvoiceDetailCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift

class InvoiceDetailCoordinator: BaseCoordinator {

    private let model: Invoice

    init(model: Invoice, navigationController: UINavigationController) {
        self.model = model
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = InvoiceDetailViewController.instantiate()
        view.viewModelBuilder = { [model] in
            return InvoiceDetailViewModel(input: $0,
                                   dependencies: (invoice: model, ()),
                                   api: InvoicesService.shared)
        }
        navigationController.pushViewController(view, animated: true)
    }
}
