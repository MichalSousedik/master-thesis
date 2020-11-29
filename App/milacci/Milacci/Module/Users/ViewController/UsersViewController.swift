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
import RxDataSources

class UsersViewController: UIViewController, Storyboardable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewFooter: UIView!
    @IBOutlet weak var loadingIndicatorView: UIView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!

    let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    private let loadingSubject = PublishSubject<Void>()
    private let loadNextSubject = PublishSubject<Void>()

    private var viewModel: UsersViewPresentable!
    var viewModelBuilder: UsersViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()
    var titleText: String!
    var searchFieldText: String!

    var dataSource: RxTableViewSectionedAnimatedDataSource<UserItemsSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = self.viewModelBuilder(
            (
                employeeSelect: tableView.rx.modelSelected(UserViewModel.self).asDriver(),
                refreshTrigger: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
                loadNextPageTrigger: loadNextSubject.asDriver(onErrorDriveWith: .empty()),
                searchTextTrigger: searchController.searchBar.rx.text.orEmpty
                    .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                    .distinctUntilChanged()
                    .asDriver(onErrorDriveWith: .empty()),
                loadingTrigger: loadingSubject.asDriver(onErrorJustReturn: ())
            )
        )
        self.setupDataSource()
        self.setupUI()
        self.setupBinding()
        self.setupViewBinding()
    }

    func setupViewBinding() {
        tableView.rx.willDisplayCell.bind {[loadNextSubject, tableView] (cell, indexPath) in
            if let tableView = tableView,
               indexPath.section == tableView.numberOfSections - 1 &&
                indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                loadNextSubject.onNext(())
            }
        }.disposed(by: bag)
    }

    func setupUI() {
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = titleText
        self.tableView.refreshControl = refreshControl
        //https://stackoverflow.com/questions/25902288/detected-a-case-where-constraints-ambiguously-suggest-a-height-of-zero
        self.tableView.rowHeight = 44
        self.refreshControl.tintColor = .label
        self.tableView.tableFooterView = self.tableViewFooter
        self.tableView.tableFooterView?.isHidden = true
        self.loadMoreActivityIndicator.startAnimating()
        self.setupSearchController()
        self.handleTableViewSizeOnKeyboard()
    }

    func setupBinding() {
        self.viewModel.output.employees
            .drive(tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: bag)

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
            } else {
                self?.tableView.tableFooterView?.isHidden = false
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
        searchController.searchBar.placeholder = searchFieldText
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.tintColor = Asset.Colors.primary1.color
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}

private extension UsersViewController {

    func showLoadingIndicator() {
        self.loadingIndicatorView.isHidden = false
    }

    func removeLoadingIndicator() {
        self.loadingIndicatorView.isHidden = true
    }

}

private extension UsersViewController {

    func setupDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<UserItemsSection>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .automatic,
                                                           reloadAnimation: .none,
                                                           deleteAnimation: .fade),
            configureCell: configureCell
        )

        dataSource.titleForHeaderInSection = { (datasource, index) in
            let section = datasource[index]
            return section.model
        }
    }
    private var configureCell: RxTableViewSectionedAnimatedDataSource<UserItemsSection>.ConfigureCell {
        return { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as!  UserTableViewCell
            cell.configure(usingViewModel: item)
            return cell
        }
    }

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
