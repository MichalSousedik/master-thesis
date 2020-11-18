//
//  EmployeeDetailViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 12/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class EmployeeProfileViewController: ProfileViewController {

    private let bag = DisposeBag()
    let editHourlyRateTrigger = PublishRelay<Void>()
    let editPersonalInfoTrigger = PublishRelay<Void>()

    override func provideViewPresentableInput() -> UserProfileViewPresentable.Input {
        return (
            signOut: .empty(),
            refresh: refresh.asDriver(onErrorDriveWith: .empty())
        )
    }

    override func provideEditableViewPresentableInput() -> UserProfileViewPresentable.EditableInput {
        return (
            hourRateEditTrigger: editHourlyRateTrigger.asDriver(onErrorDriveWith: .empty()),
            personalInfoEditTrigger: editPersonalInfoTrigger.asDriver(onErrorDriveWith: .empty())
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileDetailViewController.editHourlyRateButton.rx.tap.bind(to: editHourlyRateTrigger).disposed(by: bag)
        userProfileDetailViewController.editPersonalInfoButton.rx.tap.bind(to: editPersonalInfoTrigger).disposed(by: bag)
    }

}
