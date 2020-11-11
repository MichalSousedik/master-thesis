//
//  EmployeeViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import Alamofire

protocol EmployeesViewPresentable {

    typealias Input = (
        employeeSelect: Driver<EmployeeViewModel>,
        refreshTrigger: Driver<Void>,
        loadNextPageTrigger: Driver<Void>,
        searchTextTrigger: Driver<String>,
        loadingTrigger: Driver<Void>
    )

    typealias Output = (
        employees: Driver<[EmployeeViewModel]>,
        isLoading: Driver<Bool>,
        isRefreshing: Driver<Bool>,
        isLoadingMore: Driver<Bool>,
        errorOccured: Driver<Error>
    )

    typealias ViewModelBuilder = (EmployeesViewPresentable.Input) -> EmployeesViewPresentable

    var input: Input { get }
    var output: Output { get }

}

class EmployeesViewModel: EmployeesViewPresentable{

    var input: Input
    var output: Output
    private let api: UserAPI
    private let bag = DisposeBag()

    typealias State = (employees: BehaviorRelay<[Employee]>,
                       isRefreshing: PublishRelay<Bool>,
                       isLoadingMore: PublishRelay<Bool>,
                       isLoading: PublishRelay<Bool>,
                       errorOccured: PublishRelay<Error>)
    private let state: State = (employees: BehaviorRelay<[Employee]>(value: []),
                                isRefreshing: PublishRelay<Bool>(),
                                isLoadingMore: PublishRelay<Bool>(),
                                isLoading: PublishRelay<Bool>(),
                                errorOccured: PublishRelay<Error>())

    typealias RoutingAction = PublishRelay<UserDetail>
    private let router: RoutingAction = PublishRelay()
    typealias Routing = Driver<UserDetail>
    lazy var routing: Routing = router.asDriver(onErrorDriveWith: .empty())

    init(input: EmployeesViewPresentable.Input, api: UserAPI){
        self.input = input
        self.output = EmployeesViewModel.output(state: self.state)
        self.api = api
        self.processInput()
    }

}

private extension EmployeesViewModel {

    func processInput() {
        self.handleEmployeeSelect()

        let source = PaginationWithSearchUISource(refresh: Observable.merge(self.input.refreshTrigger.asObservable(), self.input.loadingTrigger.asObservable()),
                                        loadNextPage: self.input.loadNextPageTrigger.asObservable(),
                                        searchText: self.input.searchTextTrigger.asObservable())
        let sink = PaginationWithSearchSink(uiSource: source, loadData: ({[load] in
            return load($0, UserSettingsService.shared.userId, $1)
        }) )

        input.refreshTrigger.drive {[state] _ in
            state.isRefreshing.accept(true)
        }.disposed(by: bag)
        input.loadNextPageTrigger.drive {[state] _ in
            state.isLoadingMore.accept(true)
        }.disposed(by: bag)
        input.searchTextTrigger.drive {[state] _ in
            state.isLoading.accept(true)
        }.disposed(by: bag)
        input.loadingTrigger.drive {[state] _ in
            state.isLoading.accept(true)
        }.disposed(by: bag)

        sink.isLoading.filter{!$0}.bind {[state] _ in
            state.isLoading.accept(false)
            state.isRefreshing.accept(false)
            state.isLoadingMore.accept(false)
        }.disposed(by: bag)
        sink.elements.bind(to: state.employees)
            .disposed(by: bag)
        sink.error.bind(to: state.errorOccured)
            .disposed(by: bag)
    }

    func load(page: Int, teamLeader: Int?, searchedText: String?) -> Observable<[Employee]> {
        return self.api.fetch(page: page, teamLeaderId: teamLeader, searchedText: searchedText)
            .asObservable()
    }

    static func output(state: State) -> EmployeesViewPresentable.Output {
        let employeesViewModels = state.employees
            .map ({
                $0.compactMap { (employee) in
                    EmployeeViewModel(withEmployee: employee)
            }
        }).asDriver(onErrorJustReturn: [])
        return (
            employees: employeesViewModels,
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false),
            isRefreshing: state.isRefreshing.asDriver(onErrorJustReturn: false),
            isLoadingMore: state.isLoadingMore.asDriver(onErrorJustReturn: false),
            errorOccured: state.errorOccured.asDriver(onErrorRecover: {
                .just($0)
            })
        )
    }
}

private extension EmployeesViewModel {

    func handleEmployeeSelect() {
        self.input.employeeSelect
            .map { _ in
                print("Invoice selected")
            }
            .drive()
            .disposed(by: bag)
    }

}
