//
//  EmployeeDetailViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 12/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class EmployeeProfileViewController: ProfileViewController {

    override func provideViewPresentableInput() -> UserProfileViewPresentable.Input {
        return (
            signOut: .empty(),
            refresh: refresh.asDriver(onErrorDriveWith: .empty())
        )
    }

}
