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
import Alamofire
import MobileCoreServices
import SafariServices

class InvoicesViewController: UIViewController, Storyboardable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewFooter: UIView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!

    private var viewModel: InvoicesViewPresentable!
    private let refreshControl = UIRefreshControl()
    private let refreshSubject = PublishSubject<Void>()
    private var loadingViewController: LoadingViewController?
    private let resetReachedBottom = PublishSubject<Void>()
    private let filePick = PublishSubject<URL>()

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
            loadNextPageTrigger: tableView.rx.reachedBottom(reset: resetReachedBottom),
            filePick: filePick.asDriver(onErrorDriveWith: .empty())
        ))
        setupUI()
        setupViewModelBinding()
        setupViewBinding()
        refreshInvoices()
        showLoadingIndicator()
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
        }).disposed(by: bag)

        self.viewModel.output.errorOccured.drive(onNext: {[weak self] error in
            guard let self = self else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.handle(error, retryHandler: { [weak self] in
                    self?.refreshInvoices()
                })                }
        }).disposed(by: bag)

        self.viewModel.output.showUrl.drive(onNext: { [weak self] url in
            guard let self = self else { return }
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            self.present(vc, animated: true)
        }).disposed(by: bag)

        self.viewModel.output.pickFile.drive(onNext: { [weak self] invoiceViewModel in
            guard let self = self else { return }
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeSpreadsheet)], in: .open)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true)
        }).disposed(by: bag)

        self.viewModel.output.isUploadingFile.drive(onNext: {[weak self] uploading in
            if uploading.isUploading {
                self?.showLoadingIndicator()
            } else {
                self?.removeLoadingIndicator()
            }
        }).disposed(by: bag)
    }

    func setupViewBinding() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe({[weak self] _ in
                self?.refreshInvoices()
                self?.resetReachedBottom.onNext(())
            }).disposed(by: bag)
        tableView.rx.reachedBottom(reset: resetReachedBottom).drive(onNext: { [weak self] in
            self?.tableView.tableFooterView?.isHidden = false
        }).disposed(by: bag)
    }

    func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.refreshControl = refreshControl
        self.refreshControl.tintColor = .label
        self.tableView.tableFooterView = self.tableViewFooter
        self.tableView.tableFooterView?.isHidden = true
        self.loadMoreActivityIndicator.startAnimating()
    }

}

extension InvoicesViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            handle(ViewControllerError.selectedUrlIsNotAccessible, retryHandler: nil)
            return
        }
        filePick.onNext(url)
    }
}

private extension InvoicesViewController {

    func refreshInvoices(){
        self.refreshSubject.onNext(())
    }

    func hideLoadingIndicator(){
        self.removeLoadingIndicator()
        self.refreshControl.endRefreshing()
        self.tableView.tableFooterView?.isHidden = true
    }

    func showLoadingIndicator() {
        if self.loadingViewController == nil {
            let loadingViewController = LoadingViewController()
            self.loadingViewController = loadingViewController
            self.add(loadingViewController)
        }
    }

    func removeLoadingIndicator() {
        self.loadingViewController?.remove()
        self.loadingViewController = nil
    }

}

