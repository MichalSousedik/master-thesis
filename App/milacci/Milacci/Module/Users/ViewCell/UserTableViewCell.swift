//
//  EmployeeTableViewCell.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    static let identifier: String = "UserTableViewCell"

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!

    func configure(usingViewModel viewModel: UserViewModel) {
        self.firstName.text = viewModel.firstName
        self.lastName.text = viewModel.lastName
    }

}
