//
//  HourRateStatsViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 20/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import MonthYearPicker
import RxSwift
import RxCocoa
import RxDataSources

class HourRateStatsViewController: UIViewController, Storyboardable {

    @IBOutlet weak var periodTextField: UITextField!
    @IBOutlet weak var averagePercentageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewFooter: UIView!
    @IBOutlet weak var loadingIndicatorView: UIView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!

    private let refreshControl = UIRefreshControl()
    private let loadingSubject = PublishSubject<Void>()
    private var viewModel: HourRateStatsViewPresentable!
    var viewModelBuilder: HourRateStatsViewPresentable.ViewModelBuilder!
    var datePicker: MonthYearPickerView?
    let bag = DisposeBag()

    var dataSource: RxTableViewSectionedAnimatedDataSource<UserHourRateItemsSection>!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = self.viewModelBuilder(
            (
                periodChanged: periodTextField.rx.controlEvent(.editingDidEnd)
                    .map{[weak self] _ in
                        return self?.datePicker?.date ?? Date()
                    }
                    .asDriver(onErrorJustReturn: Date()),
                refreshTrigger: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
                loadNextPageTrigger: tableView.rx.reachedBottom(),
                loadingTrigger: loadingSubject.asDriver(onErrorJustReturn: ())
            )
        )

        setupDataSource()
        setupUI()
        showSkeleton()
        setupViewBinding()
        setupBinding()
        showLoadingIndicator()
        refresh()
    }

}

private extension HourRateStatsViewController {

    func setupDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<UserHourRateItemsSection>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .automatic,
                                                           reloadAnimation: .none,
                                                           deleteAnimation: .none),
            configureCell: configureCell
        )

        dataSource.titleForHeaderInSection = { (datasource, index) in
            let section = datasource[index]
            return section.model
        }
    }

    var configureCell: RxTableViewSectionedAnimatedDataSource<UserHourRateItemsSection>.ConfigureCell {
        return { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: UserHourRateViewCell.identifier, for: indexPath) as!  UserHourRateViewCell
            cell.configure(usingViewModel: item)
            return cell
        }
    }

    func showSkeleton() {
        self.averagePercentageLabel.showAnimatedSkeleton()
    }

    func setupUI() {
        self.tableView.refreshControl = refreshControl
        self.refreshControl.tintColor = .black
        self.tableView.tableFooterView = self.tableViewFooter
        self.tableView.tableFooterView?.isHidden = true
        self.loadMoreActivityIndicator.startAnimating()
        setupMonthYearPicker()
    }

    func setupMonthYearPicker() {
        datePicker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (view.bounds.height - 216) / 2), size: CGSize(width: view.bounds.width, height: 216)))
        periodTextField.inputView = datePicker
        datePicker?.date = Date()
        datePicker?.rx.controlEvent(.valueChanged).bind{ [periodTextField, datePicker] in
            periodTextField?.text = datePicker?.date.monthYearFormat
        }.disposed(by: bag)
        periodTextField.text = Date().monthYearFormat
        periodTextField.setRightIcon(image: UIImage(systemSymbol: .chevronDown))
    }

    func setupViewBinding() {
        tableView.rx.reachedBottom().drive(onNext: { [weak self] in
            self?.tableView.tableFooterView?.isHidden = false
        }).disposed(by: bag)
        periodTextField.rx.controlEvent(.editingDidEnd).bind {[weak self] _ in
            self?.averagePercentageLabel?.showAnimatedSkeleton()
        }.disposed(by: bag)
    }

    func setupBinding() {
        self.viewModel.output.usersHourRates
            .drive(tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: bag)

        self.viewModel.output.percentageIncrease.drive {[averagePercentageLabel]  in
            averagePercentageLabel?.text = $0
            averagePercentageLabel?.hideSkeleton()
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

}

private extension HourRateStatsViewController {

    func showLoadingIndicator() {
        self.loadingIndicatorView.isHidden = false
    }

    func removeLoadingIndicator() {
        self.loadingIndicatorView.isHidden = true
    }

}

private extension HourRateStatsViewController {

    func refresh(){
        self.loadingSubject.onNext(())
    }

}
