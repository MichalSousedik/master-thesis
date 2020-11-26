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
import MobileCoreServices
import SafariServices

class InvoicesViewController: UIViewController, Storyboardable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewFooter: UIView!
    @IBOutlet weak var loadingIndicatorView: UIView!

    private let refreshControl = UIRefreshControl()
    private let loadingSubject = PublishSubject<Void>()
    private let filePick = PublishSubject<URL>()

    private var viewModel: InvoicesViewPresentable!
    var viewModelBuilder: InvoicesViewPresentable.ViewModelBuilder!
    var actionViewModel: InvoiceActionViewPresentable!
    var actionViewModelBuilder: InvoiceActionViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()

    var invoiceViewModels: [InvoiceViewModel]?

    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<InvoiceItemsSection>(configureCell: { _, tableView, indexPath, item in
        let invoiceCell = tableView.dequeueReusableCell(withIdentifier: InvoiceTableViewCell.identifier, for: indexPath) as!  InvoiceTableViewCell
        invoiceCell.configure(usingViewModel: item)
        return invoiceCell
    })

    override func viewDidLoad() {
        super.viewDidLoad()

        actionViewModel = actionViewModelBuilder((
            invoiceSelect: tableView.rx.modelSelected(InvoiceViewModel.self).asDriver(),
            invoiceActionTrigger: .empty(),
            filePick: filePick.asDriver(onErrorDriveWith: .empty())
        ))

        viewModel = viewModelBuilder((
            refreshTrigger: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
            loadNextPageTrigger: tableView.rx.reachedBottom(),
            loadingTrigger: loadingSubject.asDriver(onErrorJustReturn: ()),
            invoiceChanged: actionViewModel.output.invoiceChanged
        ))

        dataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }
        tableView.rx.setDelegate(self).disposed(by: bag)

        setupUI()
        setupViewModelBinding()
        setupViewBinding()
        showLoadingIndicator()
    }
}

extension InvoicesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
        if let invoiceViewModels = invoiceViewModels {

            let invoiceViewModel = invoiceViewModels[indexPath.row]

            if (invoiceViewModel.invoice.state == .notIssued ||
                    invoiceViewModel.invoice.state == .waiting) && invoiceViewModel.canDownloadFile {
                let action = UIContextualAction(style: .normal, title: L10n.reuploadInvoice) { (_, _, success: (Bool)->Void) in
                    self.pickFile()
                    success(true)
                }
                action.backgroundColor = Asset.Colors.primary1.color
                actions.append(action)
            }
        }

        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}

private extension InvoicesViewController {

    func setupViewModelBinding() {
        self.viewModel.output.invoices
            .drive(tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: bag)

        self.viewModel.output.invoices.drive { [weak self] in
            self?.invoiceViewModels = $0.flatMap({ (sectionModel) in
                sectionModel.items
            })
        }.disposed(by: bag)

        self.viewModel.output.isLoading.drive(onNext: { [weak self] isLoading in
            if(isLoading) {
                self?.showLoadingIndicator()
            } else {
                self?.removeLoadingIndicator()
            }
        }).disposed(by: bag)

        self.viewModel.output.isRefreshing.drive(onNext: { [weak self] isLoading in
            if(!isLoading) {
                self?.refreshControl.endRefreshing()
            }
        }).disposed(by: bag)

        self.viewModel.output.isLoadingMore.drive(onNext: { [weak self] isLoading in
            if(!isLoading) {
                self?.tableView.tableFooterView?.isHidden = true
            }
        }).disposed(by: bag)

        self.viewModel.output.errorOccured.drive(onNext: {[weak self] error in
            guard let self = self else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.handle(error, retryHandler: { [weak self] in
                    self?.loadingSubject.onNext(())
                })                }
        }).disposed(by: bag)

        self.actionViewModel.output.showUrl.drive(onNext: { [weak self] url in
            guard let self = self else { return }
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            self.present(vc, animated: true)
        }).disposed(by: bag)

        self.actionViewModel.output.pickFile.drive(onNext: { [weak self] invoiceViewModel in
            guard let self = self else { return }
            self.pickFile()
        }).disposed(by: bag)

        self.actionViewModel.output.isProcessingInvoice.drive(onNext: {[weak self] uploading in
            if uploading.isProcessing {
                self?.showLoadingIndicator()
            } else {
                self?.removeLoadingIndicator()
            }
        }).disposed(by: bag)

        self.actionViewModel.output.info.drive(onNext: {[weak self] (message) in
            let alert = UIAlertController(
                title: L10n.noActionAvailable,
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(
                title: L10n.cancel,
                style: .default
            ))
            self?.present(alert, animated: true)
        }).disposed(by: bag)

    }

    func setupViewBinding() {
        tableView.rx.reachedBottom().drive(onNext: { [weak self] in
            self?.tableView.tableFooterView?.isHidden = false
        }).disposed(by: bag)
    }

    func setupUI() {
        self.tableView.refreshControl = refreshControl
        self.refreshControl.tintColor = .label
        self.tableView.tableFooterView = self.tableViewFooter
        self.tableView.tableFooterView?.isHidden = true
    }

    func pickFile() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .open)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
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

    func showLoadingIndicator() {
        self.loadingIndicatorView.isHidden = false
    }

    func removeLoadingIndicator() {
        self.loadingIndicatorView.isHidden = true
    }

}

