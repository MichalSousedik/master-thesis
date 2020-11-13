//
//  EmployeeDetailCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 12/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
import SFSafeSymbols

class EmployeeDetailCoordinator: BaseCoordinator {

    private let userDetail: UserDetail

    init(userDetail: UserDetail, navigationController: UINavigationController) {
        self.userDetail = userDetail
        super.init()
        self.navigationController = navigationController
    }

    override func start(){
        let view = EmployeeDetailViewController.instantiate()
        view.viewModelBuilder = { [userDetail] in
            return UserProfileViewModel(input: $0,
                                        dependencies: (
                                            api: UserService.shared,
                                            userIdProvider: {userDetail.id},
                                            userDetail: userDetail))
        }
        view.userProfileHeaderViewController = UserProfileHeaderViewController.instantiate()
        view.userProfileDetailViewController = UserProfileDetailViewController.instantiate()
//        view.wageViewController = WageViewController.instantiate()
//
//        self.setupHourlyRateViewController(view: view.wageViewController)
//        self.setupChartViewController(view: view.wageViewController)

        navigationController.pushViewController(view, animated: true)
        self.setupNavigationBar()
    }

//    func setupHourlyRateViewController(view: WageViewController) {
//        view.hourlyRateViewController = HourlyRateViewController.instantiate()
//        view.hourlyRateViewController.viewModelBuilder = { [userIdProvider] in
//            return HourlyRateViewModel(input: $0,
//                                      dependencies: (
//                                        api: UserService.shared,
//                                        userIdProvider: userIdProvider))
//        }
//    }
//
//    func setupChartViewController(view: WageViewController) {
//        view.wageChartViewController = WageChartViewController.instantiate()
//        view.wageChartViewController.viewModelBuilder = { [userIdProvider] in
//            return WageChartViewModel(input: $0,
//                                      dependencies: (
//                                        api: InvoiceService.shared,
//                                        userIdProvider: userIdProvider))
//        }
//    }

    func setupNavigationBar(){
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .none
        navigationBarAppearence.backgroundColor = Asset.Colors.primary.color
        navigationController.navigationBar.standardAppearance = navigationBarAppearence

    }

}
