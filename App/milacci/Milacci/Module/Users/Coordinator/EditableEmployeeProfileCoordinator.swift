//
//  EditableEmployeeProfileCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 14/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift

class EditableEmployeeProfileCoordinator: EmployeeProfileCoordinator {

    let bag = DisposeBag()
    var viewModel: EditableUserProfileViewModel?

    override init(userDetail: UserDetail, navigationController: UINavigationController) {
        super.init(userDetail: userDetail, navigationController: navigationController)
    }

    override func modifyDetailViewController() -> ModifyDetailViewController {
        { (vc: UserProfileDetailViewController) in
            super.modifyDetailViewController()(vc)
            vc.editPersonalInfoButton.isHidden = false
            vc.editHourlyRateButton.isHidden = false
        }
    }

    override func provideViewModelBuilder() -> UserProfileViewPresentable.ViewModelBuilder {
        { [weak self, userIdProvider, userDetail, bag] in
            let vm = EditableUserProfileViewModel(input: $0,
                                                  editableInput: $1,
                                                  dependencies: (
                                                    api: UserService.shared,
                                                    userIdProvider: userIdProvider,
                                                    userDetail: userDetail
                                                  ))
            vm.hourRateRouter.map { [weak self] (model) in
                self?.showEditHourRate(usingModel: model)
            }.subscribe()
            .disposed(by: bag)

            vm.personalInfoRouter.map { [weak self] (model) in
                self?.showEditPersonalInfo(usingModel: model)
            }.subscribe()
            .disposed(by: bag)
            self?.viewModel = vm
            return vm
        }
    }

    func showEditHourRate(usingModel model: UserDetail) {
        let coordinator = EditHourlyRateCoordinator(model: model, navigationController: navigationController)
        coordinator.router.bind {[weak self] _ in
            self?.viewModel?.refresh()
        }.disposed(by: bag)
        self.add(coordinator: coordinator)
        coordinator.start()
    }

    func showEditPersonalInfo(usingModel model: UserDetail) {
        let coordinator = EditPersonalInfoCoordinator(model: model, navigationController: navigationController)
        coordinator.complete.bind {[weak self] in
            self?.viewModel?.state.userDetail.accept($0)
        }.disposed(by: bag)
        self.add(coordinator: coordinator)
        coordinator.start()
    }

}

