//
//  EmployeeViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmployeesViewController: UIViewController, Storyboardable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewFooter: UIView!
    @IBOutlet weak var loadingIndicatorView: UIView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!

    let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    private let loadingSubject = PublishSubject<Void>()

    private var viewModel: EmployeesViewPresentable!
    var viewModelBuilder: EmployeesViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()

    var items: [EmployeeViewPresentable] = []
    var sections = [FirstLetterGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = self.viewModelBuilder(
            (
                employeeSelect: .empty(),
                refreshTrigger: refreshControl.rx.controlEvent(.valueChanged).debug().asDriver(onErrorJustReturn: ()),
                loadNextPageTrigger: tableView.rx.reachedBottom(),
                searchTextTrigger: searchController.searchBar.rx.text.orEmpty
                    .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                    .distinctUntilChanged()
                    .asDriver(onErrorDriveWith: .empty()),
                loadingTrigger: loadingSubject.asDriver(onErrorJustReturn: ())
            )
        )
        self.setupUI()
        self.setupBinding()
        self.setupViewBinding()
    }

    func setupViewBinding() {
        tableView.rx.reachedBottom().drive(onNext: { [weak self] in
            self?.tableView.tableFooterView?.isHidden = false
        }).disposed(by: bag)
    }

    func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.refreshControl = refreshControl
        self.refreshControl.tintColor = .label
        self.tableView.tableFooterView = self.tableViewFooter
        self.tableView.tableFooterView?.isHidden = true
        self.loadMoreActivityIndicator.startAnimating()
        self.setupSearchController()
        self.handleTableViewSizeOnKeyboard()
    }

    func setupBinding() {
        self.viewModel.output.employees.drive { [weak self] (employees) in
            self?.sections = Dictionary(grouping: employees) { (employee) in
                return String(Array(employee.lastName)[0]).uppercased()
            }.map({ (firstLetter, employees) in
                return FirstLetterGroup(firstLetter: firstLetter, employees: employees)
            }).sorted()
            self?.items = employees
            self?.tableView.reloadData()
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

    }

    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = L10n.searchTeamMember
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.tintColor = Asset.Colors.primary1.color
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}

extension EmployeesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.firstLetter
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.employees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier, for: indexPath) as? EmployeeTableViewCell
        let employee = sections[indexPath.section].employees[indexPath.row]

        cell?.configure(usingViewModel: employee)
        return cell!
    }

}

private extension EmployeesViewController {

    func showLoadingIndicator() {
        self.loadingIndicatorView.isHidden = false
    }

    func removeLoadingIndicator() {
        self.loadingIndicatorView.isHidden = true
    }

}

private extension EmployeesViewController {

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
