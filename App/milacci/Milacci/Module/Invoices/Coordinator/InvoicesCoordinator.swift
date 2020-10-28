//
//  InvoicesCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 21/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift

class InvoicesCoordinator: BaseCoordinator {

    private let bag = DisposeBag()

    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = InvoicesViewController.instantiate()
        let service = InvoicesService.shared
        view.viewModelBuilder = { [bag] in
            let viewModel = InvoicesViewModel(input: $0, api: service)

            viewModel.routing.map { [weak self] (invoice) in
                self?.showInvoiceDetail(usingModel: invoice)
            }
            .drive()
            .disposed(by: bag)

            return viewModel
        }
        view.tabBarItem = UITabBarItem(title: "Faktury", image: UIImage(systemName: "doc.fill"), tag: 0)
        navigationController.pushViewController(view, animated: true)
    }

    func showInvoiceDetail(usingModel model: Invoice){
        let invoiceDetailCoordinator = InvoiceDetailCoordinator(model: model, navigationController: navigationController)
        self.add(coordinator: invoiceDetailCoordinator)
        invoiceDetailCoordinator.start()

    }

}
