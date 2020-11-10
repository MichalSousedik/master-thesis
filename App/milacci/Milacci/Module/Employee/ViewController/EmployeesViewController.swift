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

    private let refreshControl = UIRefreshControl()
    private let refreshSubject = PublishSubject<Void>()
    private let resetReachedBottom = PublishSubject<Void>()

    private var viewModel: EmployeesViewPresentable!
    var viewModelBuilder: EmployeesViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()

    var items: [EmployeeViewPresentable] = []

    struct FirstLetterGroup: Comparable {
        static func < (lhs: EmployeesViewController.FirstLetterGroup, rhs: EmployeesViewController.FirstLetterGroup) -> Bool {
            return lhs.firstLetter < rhs.firstLetter
        }

        static func == (lhs: EmployeesViewController.FirstLetterGroup, rhs: EmployeesViewController.FirstLetterGroup) -> Bool {
            return lhs.firstLetter == rhs.firstLetter
        }

        var firstLetter: String
        var employees: [EmployeeViewModel]
    }

    var sections = [FirstLetterGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = self.viewModelBuilder(
            (
                employeeSelect: tableView.rx.modelSelected(EmployeeViewModel.self).asDriver(),
                refreshTrigger: refreshSubject.asDriver(onErrorJustReturn: ()),
                loadNextPageTrigger: tableView.rx.reachedBottom(reset: resetReachedBottom),
                searchedText: .empty()
            )
        )
        self.setupUI()
        self.setupBinding()
        self.setupViewBinding()
        showLoadingIndicator()
        refresh()
    }

    func setupViewBinding() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe({[weak self] _ in
                self?.refresh()
            }).disposed(by: bag)
        tableView.rx.reachedBottom(reset: resetReachedBottom).drive(onNext: { [weak self] in
            self?.tableView.tableFooterView?.isHidden = false
        }).disposed(by: bag)
    }

    func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.refreshControl = refreshControl
        self.refreshControl.tintColor = .label
        self.tableView.tableFooterView = self.tableViewFooter
        self.tableView.tableFooterView?.isHidden = true
        self.loadMoreActivityIndicator.startAnimating()
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
            if(!isLoading) {
                self?.hideLoadingIndicator()
            }
        }).disposed(by: bag)

        self.viewModel.output.errorOccured.drive(onNext: {[weak self] error in
            guard let self = self else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.handle(error, retryHandler: { [weak self] in
                    self?.refresh()
                })                }
        }).disposed(by: bag)

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
        let section = self.sections[indexPath.section]
        let employee = section.employees[indexPath.row]

        cell?.configure(usingViewModel: employee)
        return cell!
    }

}

private extension EmployeesViewController {

    func refresh(){
        self.refreshSubject.onNext(())
    }

    func hideLoadingIndicator(){
        self.removeLoadingIndicator()
        self.refreshControl.endRefreshing()
        self.tableView.tableFooterView?.isHidden = true
    }

    func showLoadingIndicator() {
        self.loadingIndicatorView.isHidden = false
    }

    func removeLoadingIndicator() {
        self.loadingIndicatorView.isHidden = true
    }

}
