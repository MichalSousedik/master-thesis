//
//  EditHourlyRateCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 15/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EditHourlyRateCoordinator: BaseCoordinator {

    let model: UserDetail
    let bag = DisposeBag()
    let router: PublishRelay<HourRate> = PublishRelay()

    init(model: UserDetail, navigationController: UINavigationController) {
        self.model = model
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let vc = EditHourlyRateViewController.instantiate()
        vc.viewModelBuilder = { [weak self, model, bag] in
            let vm = EditHourlyRateViewModel(input: $0, dependecies: (api: HourRateService.shared, userDetail: model))
            vm.router.bind { (hourRate) in
                self?.router.accept(hourRate)
                self?.navigationController.popViewController(animated: true)
            }.disposed(by: bag)
            return vm
        }
        navigationController.pushViewController(vc, animated: true)
        self.setupNavigationBar()
    }

    func setupNavigationBar(){
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .none
        navigationBarAppearence.backgroundColor = Asset.Colors.primary.color
        navigationController.navigationBar.standardAppearance = navigationBarAppearence
    }

}
