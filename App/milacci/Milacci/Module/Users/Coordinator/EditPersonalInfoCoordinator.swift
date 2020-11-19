//
//  EditPersonalInfoCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 18/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EditPersonalInfoCoordinator: BaseCoordinator {

    let model: UserDetail
    let bag = DisposeBag()
    let complete: PublishRelay<UserDetail> = PublishRelay()

    init(model: UserDetail, navigationController: UINavigationController) {
        self.model = model
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let vc = EditPersonalInfoViewController.instantiate()
        vc.viewModelBuilder = { [weak self, model, bag] in
            let vm = EditPersonalInfoViewModel(input: $0, dependecies: (api: UserService.shared, userDetail: model))
            vm.complete.bind { (userDetail) in
                self?.complete.accept(userDetail)
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
