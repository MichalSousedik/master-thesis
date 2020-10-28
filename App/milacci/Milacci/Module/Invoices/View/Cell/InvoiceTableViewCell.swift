 //
//  EmployeeInvoiceUITableViewCell.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {

    static let identifier: String = "InvoiceTableViewCell"

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var clipImageView: UIImageView!

    func configure(usingViewModel viewModel: InvoiceViewPresentable) {
        dateLabel.text = viewModel.date
        amountLabel.text = viewModel.value
        stateLabel.text = viewModel.state
        clipImageView.tintColor = viewModel.isFilePresent ? UIColor.label : UIColor.clear
    }

}
