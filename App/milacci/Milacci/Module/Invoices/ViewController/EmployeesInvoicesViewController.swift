//
//  EmployeesInvoicesViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 23/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import MobileCoreServices
import SafariServices
import MonthYearPicker

class EmployeesInvoicesViewController: BaseViewController, Storyboardable {

    @IBOutlet weak var periodOfIssueTextField: UITextField!
    @IBOutlet weak var invoiceStateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewFooter: UIView!
    @IBOutlet weak var loadingIndicatorView: UIView!

    private let refreshControl = UIRefreshControl()
    private let loadingSubject = PublishSubject<Void>()
    private let stateChageSubject = PublishSubject<Invoice>()

    private var viewModel: EmployeesInvoicesViewPresentable!
    var viewModelBuilder: EmployeesInvoicesViewPresentable.ViewModelBuilder!
    var actionViewModel: InvoiceActionViewPresentable!
    var actionViewModelBuilder: InvoiceActionViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()

    var datePicker: MonthYearPickerView?
    var invoiceViewModels: [InvoiceViewModel]?

    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<InvoiceItemsSection>(configureCell: { _, tableView, indexPath, item in
        let invoiceCell = tableView.dequeueReusableCell(withIdentifier: InvoiceTableViewCell.identifier, for: indexPath) as! InvoiceTableViewCell
        invoiceCell.configure(usingViewModel: item)
        return invoiceCell
    })

    override func viewDidLoad() {
        super.viewDidLoad()

        actionViewModel = actionViewModelBuilder((
            invoiceSelect: tableView.rx.modelSelected(InvoiceViewModel.self).asDriver(),
            invoiceActionTrigger: stateChageSubject.asDriver(onErrorDriveWith: .empty()),
            filePick: .empty()
        ))

        viewModel = viewModelBuilder((
            periodOfIssueTrigger: periodOfIssueTextField.rx.controlEvent(.editingDidEnd)
                .map{[weak self] _ in
                    return self?.datePicker?.date ?? Date()
                }
                .distinctUntilChanged()
                .asDriver(onErrorJustReturn: Date()),
            invoiceStateTrigger: invoiceStateSegmentedControl.rx.selectedSegmentIndex.map({ (index) in
                if let state = InvoiceState.allCases.filter({(state) in
                    state.segmentedControlOrder == index
                }).first {
                    return state
                } else {
                    fatalError("Index is not mapped to proper invoice state.")
                }
            }).asDriver(onErrorDriveWith: .empty()),
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
    }

}

extension EmployeesInvoicesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
        if let invoiceViewModels = invoiceViewModels {

            let invoiceViewModel = invoiceViewModels[indexPath.row]

            actions = invoiceViewModel.invoice.state.allowedTransitions.map {[stateChageSubject] (state) in
                let action = UIContextualAction(style: .normal, title: "\(state.icon)\n\(state.description)") { (_, _, success: (Bool)->Void) in
                    stateChageSubject.onNext(Invoice(invoiceViewModel.invoice, state: state))
                    success(true)
                }
                action.backgroundColor = state.backgroundColor
                return action
            }
        }

        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}

private extension EmployeesInvoicesViewController {

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

        self.actionViewModel.output.isProcessingInvoice.drive(onNext: { [weak self] invoiceProcessing in
            if(invoiceProcessing.isProcessing) {
                self?.startModalLoader()
            } else {
                self?.stopModalLoader()
            }
        }).disposed(by: bag)

        self.actionViewModel.output.showUrl.drive(onNext: { [weak self] url in
            guard let self = self else { return }
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.present(vc, animated: true)
            }
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
        self.handleTableViewSizeOnKeyboard()
        setupMonthYearPicker()
        setupSegmentedControl()
    }

    func setupSegmentedControl() {
        InvoiceState.allCases.forEach{[invoiceStateSegmentedControl] state in
            invoiceStateSegmentedControl?.setTitle(state.description, forSegmentAt: state.segmentedControlOrder)
        }
    }

    func setupMonthYearPicker() {
        datePicker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (view.bounds.height - 216) / 2), size: CGSize(width: view.bounds.width, height: 216)))
        periodOfIssueTextField.inputView = datePicker
        datePicker?.date = Date()
        datePicker?.rx.controlEvent(.valueChanged).bind{ [periodOfIssueTextField, datePicker] in
            periodOfIssueTextField?.text = datePicker?.date.monthYearFormat
        }.disposed(by: bag)
        datePicker?.maximumDate = Date()
        periodOfIssueTextField.text = Date().monthYearFormat
        periodOfIssueTextField.setRightIcon(image: UIImage(systemSymbol: .chevronDown))
    }

}

private extension EmployeesInvoicesViewController {

    func showLoadingIndicator() {
        self.loadingIndicatorView.isHidden = false
    }

    func removeLoadingIndicator() {
        self.loadingIndicatorView.isHidden = true
    }

}

private extension EmployeesInvoicesViewController {

    func handleTableViewSizeOnKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}
