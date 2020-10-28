//
//  InvoicesViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import GoogleSignIn
import RxCocoa
import RxSwift

class InvoicesViewController: UIViewController, Storyboardable {

    @IBOutlet var tableView: UITableView!

    private var viewModel: InvoicesViewPresentable!
    var viewModelBuilder: InvoicesViewPresentable.ViewModelBuilder!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = viewModelBuilder()
//        invoicesViewModel.invoices.bind(to: tableView.rx.items(cellIdentifier: InvoiceTableViewCell.identifier)) { row, model, cell in
//            guard let cell = cell as? InvoiceTableViewCell else {
//                    fatalError("The dequeued cell is not an instance \(NSStringFromClass(InvoiceTableViewCell.classForCoder()))")
//            }
//            cell.viewModel = self.invoicesViewModel?.createCellViewModel(forIndex: row)
//        }.disposed(by: disposeBag)
    }

}

