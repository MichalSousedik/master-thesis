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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var clipImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var rowActionImageView: UIImageView!
    func configure(usingViewModel viewModel: InvoiceViewModel) {
        titleLabel.text = viewModel.title
        amountLabel.text = viewModel.value
        stateLabel.text = viewModel.state
        clipImageView.tintColor = viewModel.canDownloadFile ? UIColor.label : UIColor.clear
        rowActionImageView.tintColor = .secondaryLabel

        if viewModel.canUploadFile {
            rowActionImageView.image = UIImage(systemSymbol: .squareAndArrowUp, withConfiguration: nil)
        } else if viewModel.canDownloadFile {
            rowActionImageView.image = UIImage(systemSymbol: .squareAndArrowDown, withConfiguration: nil)
        } else {
            rowActionImageView.tintColor = .clear
        }
    }

}
