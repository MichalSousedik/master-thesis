//
//  UserHourRateViewCell.swift
//  Milacci
//
//  Created by Michal Sousedik on 21/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class UserHourRateViewCell: UITableViewCell {

    static let identifier: String = "UserHourRateViewCell"

    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastHourlyRateLabel: UILabel!
    @IBOutlet weak var newHourlyRateLabel: UILabel!

    func configure(usingViewModel viewModel: UserHourRateViewModel) {
        self.percentageLabel.text = viewModel.percentageIncrease
        self.nameLabel.text = "\(viewModel.firstname) \(viewModel.lastname)"
        self.lastHourlyRateLabel.text = viewModel.lastHourlyRate
        self.newHourlyRateLabel.text = viewModel.newHourlyRate
    }

}
