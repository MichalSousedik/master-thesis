//
//  EditableEmployeeProfileCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 14/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class EditableEmployeeProfileCoordinator: EmployeeProfileCoordinator {

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

}

