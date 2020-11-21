//
//  HourRateStatsViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 20/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources


protocol HourRateStatsViewPresentable {

    typealias Input = (
        periodChanged: Driver<Date>,
        refreshTrigger: Driver<Void>,
        loadNextPageTrigger: Driver<Void>,
        loadingTrigger: Driver<Void>
    )

    typealias Output = (
        percentageIncrease: Driver<String>,
        usersHourRates: Driver<[UserHourRateItemsSection]>,
        isLoading: Driver<Bool>,
        isRefreshing: Driver<Bool>,
        isLoadingMore: Driver<Bool>,
        errorOccured: Driver<Error>
    )

    typealias ViewModelBuilder = (HourRateStatsViewPresentable.Input) -> HourRateStatsViewPresentable
    typealias Dependencies = (userAPI: UserAPI, hourRateAPI: HourRateAPI)

    var input: Input { get }
    var output: Output { get }

}

class HourRateStatsViewModel: HourRateStatsViewPresentable {

    private let bag = DisposeBag()

    var input: Input
    var output: Output
    var userAPI: UserAPI
    var hourRateAPI: HourRateAPI

    typealias State = (percentageIncrease: PublishRelay<[HourRateStat]>,
                       userDetails: BehaviorRelay<[UserDetail]>,
                       isRefreshing: PublishRelay<Bool>,
                       isLoadingMore: PublishRelay<Bool>,
                       isLoading: BehaviorRelay<Bool>,
                       errorOccured: PublishRelay<Error>)
    private let state: State = (percentageIncrease: PublishRelay(),
                                userDetails: BehaviorRelay(value: []),
                                isRefreshing: PublishRelay<Bool>(),
                                isLoadingMore: PublishRelay<Bool>(),
                                isLoading: BehaviorRelay<Bool>(value: false),
                                errorOccured: PublishRelay<Error>())

    init(input: HourRateStatsViewPresentable.Input, dependencies: HourRateStatsViewPresentable.Dependencies){
        self.input = input
        self.output = HourRateStatsViewModel.output(state: self.state)
        self.userAPI = dependencies.userAPI
        self.hourRateAPI = dependencies.hourRateAPI
        self.processInput()
        self.loadHourRateState(date: Date())
    }

    func load(page: Int) -> Observable<[UserDetail]> {
        return self.userAPI.fetch(page: page, teamLeaderId: nil, searchedText: nil).asObservable()
    }
}

private extension HourRateStatsViewModel {

    func processInput() {
        let source = PaginationUISource(refresh: Observable.merge(self.input.refreshTrigger.asObservable(), self.input.loadingTrigger.asObservable()),
                                                  loadNextPage: self.input.loadNextPageTrigger.asObservable())
        let sink = PaginationSink(uiSource: source, loadData: load(page:))

        input.periodChanged.drive {[weak self] in
            self?.loadHourRateState(date: $0)
        }.disposed(by: bag)

        input.refreshTrigger.drive {[state] _ in
            state.isRefreshing.accept(true)
        }.disposed(by: bag)
        input.loadNextPageTrigger.drive {[state] _ in
            state.isLoadingMore.accept(true)
        }.disposed(by: bag)
        input.loadingTrigger.drive {[state] _ in
            state.isLoading.accept(true)
        }.disposed(by: bag)

        sink.isLoading.filter{!$0}.bind {[state] _ in
            state.isLoading.accept(false)
            state.isRefreshing.accept(false)
            state.isLoadingMore.accept(false)
        }.disposed(by: bag)
        sink.elements.bind(to: state.userDetails)
            .disposed(by: bag)
        sink.error.bind(to: state.errorOccured)
            .disposed(by: bag)

    }

    func loadHourRateState(date: Date) {
        hourRateAPI.stats(period: date)
            .subscribe {[state] (hourRateStats) in
                state.percentageIncrease.accept(hourRateStats)
            } onError: {[state] (error) in
                state.errorOccured.accept(error)
            }.disposed(by: bag)
    }
}

private extension HourRateStatsViewModel {

    static func output(state: State) -> HourRateStatsViewPresentable.Output {
        let sections = state.userDetails
            .map({
                $0.compactMap({
                    UserHourRateViewModel(withModel: $0)
                })
            })
            .map{
                return Dictionary(grouping: $0) { (employee) in
                    let lastName = employee.lastname.isEmpty ? "-" : employee.lastname
                    return String(Array(lastName)[0]).uppercased()
                }.map({ (firstLetter, employees) in
                    return FirstLetterGroupWithHourRate(firstLetter: firstLetter, employees: employees)
                }).sorted()
            }
            .map({ (firstLetterGroups) in
                firstLetterGroups.map { (firstLetterGroup) in
                    UserHourRateItemsSection(model: firstLetterGroup.firstLetter, items: firstLetterGroup.employees)
                }
            })
            .asDriver(onErrorJustReturn: [])
        return (
            percentageIncrease: state.percentageIncrease.map{ model in
                if !model.isEmpty {
                    return "\(model[0].percentageIncrease) %"
                } else {
                    return "-"
                }
            }.asDriver(onErrorJustReturn: "-"),
            usersHourRates: sections,
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false),
            isRefreshing: state.isRefreshing.asDriver(onErrorJustReturn: false),
            isLoadingMore: state.isLoadingMore.asDriver(onErrorJustReturn: false),
            errorOccured: state.errorOccured.asDriver(onErrorRecover: {
                .just($0)
            })
        )
    }

}
