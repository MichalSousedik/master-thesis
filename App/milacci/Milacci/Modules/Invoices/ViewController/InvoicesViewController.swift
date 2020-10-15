//
//  InvoicesViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class InvoicesViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewFooter: UIView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!
    
    private var viewModel: InvoicesViewPresentable!
    private let refreshControl = UIRefreshControl()
    private let refreshSubject = PublishSubject<Void>()
    
    var viewModelBuilder: InvoicesViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<InvoiceItemsSection>(configureCell: { _, tableView, indexPath, item in
        let invoiceCell = tableView.dequeueReusableCell(withIdentifier: InvoiceTableViewCell.identifier, for: indexPath) as!  InvoiceTableViewCell
        invoiceCell.configure(usingViewModel: item)
        return invoiceCell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = viewModelBuilder((
            invoiceSelect: tableView.rx.modelSelected(InvoiceViewModel.self).asDriver(),
            refreshTrigger: refreshSubject.asDriver(onErrorJustReturn: ()),
            loadNextPageTrigger: tableView.rx.reachedBottom
        ))
        setupUI()
        setupViewModelBinding()
        setupViewBinding()
        refreshInvoices()
    }
}

private extension InvoicesViewController {
    
    func setupViewModelBinding() {
        self.viewModel.output.invoices
            .drive(tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: bag)
        
        self.viewModel.output.isLoading.drive(onNext: { [weak self] isLoading in
            if(!isLoading) {
                self?.hideLoadingIndicator()
            }
        })
        .disposed(by: bag)
    }
    
    func setupViewBinding() {
        refreshControl.rx.controlEvent(.valueChanged)
        .subscribe({[weak self] _ in
            self?.refreshInvoices()
        })
        .disposed(by: bag)
        
        tableView.rx.reachedBottom.drive(onNext: { [weak self] in
            self?.tableView.tableFooterView?.isHidden = false
        })
        .disposed(by: bag)
    }
    
    func setupUI() {
        self.tableView.refreshControl = refreshControl
        self.refreshControl.tintColor = UIColor(named: "primary")
        self.tableView.tableFooterView = self.tableViewFooter
        self.tableView.tableFooterView?.isHidden = true
        self.loadMoreActivityIndicator.startAnimating()
    }

}

private extension InvoicesViewController {
    
    func refreshInvoices(){
        self.refreshSubject.onNext(())
        self.refreshControl.beginRefreshing()
    }
    
    func hideLoadingIndicator(){
        self.refreshControl.endRefreshing()
        self.tableView.tableFooterView?.isHidden = true
    }
    
}


