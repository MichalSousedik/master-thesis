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

protocol UsersViewPresentable {

    typealias Input = (
        employeeSelect: Driver<UserViewModel>,
        refreshTrigger: Driver<Void>,
        loadNextPageTrigger: Driver<Void>,
        searchTextTrigger: Driver<String>,
        loadingTrigger: Driver<Void>
    )

    typealias Output = (
        employees: Driver<[UserItemsSection]>,
        isLoading: Driver<Bool>,
        isRefreshing: Driver<Bool>,
        isLoadingMore: Driver<Bool>,
        errorOccured: Driver<Error>
    )

    typealias ViewModelBuilder = (UsersViewPresentable.Input) -> UsersViewPresentable

    var input: Input { get }
    var output: Output { get }

}

class UsersViewModel: UsersViewPresentable{

    var input: Input
    var output: Output
    let api: UserAPI
    private let bag = DisposeBag()

    typealias State = (employees: BehaviorRelay<[Employee]>,
                       isRefreshing: PublishRelay<Bool>,
                       isLoadingMore: PublishRelay<Bool>,
                       isLoading: BehaviorRelay<Bool>,
                       errorOccured: PublishRelay<Error>)
    private let state: State = (employees: BehaviorRelay<[Employee]>(value: []),
                                isRefreshing: PublishRelay<Bool>(),
                                isLoadingMore: PublishRelay<Bool>(),
                                isLoading: BehaviorRelay<Bool>(value: false),
                                errorOccured: PublishRelay<Error>())

    typealias RoutingAction = PublishRelay<UserDetail>
    private let router: RoutingAction = PublishRelay()
    typealias Routing = Driver<UserDetail>
    lazy var routing: Routing = router.asDriver(onErrorDriveWith: .empty())

    init(input: UsersViewPresentable.Input, api: UserAPI){
        self.input = input
        self.output = UsersViewModel.output(state: self.state)
        self.api = api
        self.processInput()
    }

    func load(page: Int, searchedText: String?) -> Observable<[Employee]> {
        fatalError("Not implemented")
    }

}

private extension UsersViewModel {

    func processInput() {
        self.handleEmployeeSelect()

        let source = PaginationWithSearchUISource(refresh: Observable.merge(self.input.refreshTrigger.asObservable(), self.input.loadingTrigger.asObservable()),
                                                  loadNextPage: self.input.loadNextPageTrigger.asObservable(),
                                                  searchText: self.input.searchTextTrigger.asObservable())
        let sink = PaginationWithSearchSink(uiSource: source, loadData: ({[load] in
            return load($0, $1)
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

    static func output(state: State) -> UsersViewPresentable.Output {
        let sections = state.employees
            .map({
                $0.compactMap({
                    UserViewModel(withEmployee: $0)
                })
            })
            .map{
                return Dictionary(grouping: $0) { (employee) in
                    let lastName = employee.lastName.isEmpty ? "-" : employee.lastName
                    return String(Array(lastName)[0]).uppercased()
                }.map({ (firstLetter, employees) in
                    return FirstLetterGroup(firstLetter: firstLetter, employees: employees)
                }).sorted()
            }
            .map({ (firstLetterGroups) in
                firstLetterGroups.map { (firstLetterGroup) in
                    UserItemsSection(model: firstLetterGroup.firstLetter, items: firstLetterGroup.employees)
                }
            })
            .asDriver(onErrorJustReturn: [])

        return (
            employees: sections,
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false),
            isRefreshing: state.isRefreshing.asDriver(onErrorJustReturn: false),
            isLoadingMore: state.isLoadingMore.asDriver(onErrorJustReturn: false),
            errorOccured: state.errorOccured.asDriver(onErrorRecover: {
                .just($0)
            })
        )
    }
}

private extension UsersViewModel {

    func handleEmployeeSelect() {
        self.input.employeeSelect.drive {[router] (employeeViewModel) in
            router.accept(employeeViewModel.employee)
        }.disposed(by: bag)

    }

}
