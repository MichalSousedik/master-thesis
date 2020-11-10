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
        searchedText: Driver<String>
    )

    typealias Output = (
        employees: Driver<[EmployeeViewModel]>,
        isLoading: Driver<Bool>,
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
                       isLoading: PublishRelay<Bool>,
                       errorOccured: PublishRelay<Error>)
    private let state: State = (employees: BehaviorRelay<[Employee]>(value: []),
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

        let source = PaginationUISource(refresh: self.input.refreshTrigger.debug().asObservable(),
                                        loadNextPage: self.input.loadNextPageTrigger.asObservable())
        let sink = PaginationSink(uiSource: source, loadData: ({[load] in
            return load($0, 97, nil)
        }) )

        sink.isLoading.bind(to: state.isLoading)
            .disposed(by: bag)
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
