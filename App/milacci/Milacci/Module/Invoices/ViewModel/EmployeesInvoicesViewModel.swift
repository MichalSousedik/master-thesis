//
//  EmployeesInvoicesViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 23/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import RxRelay
import RxCocoa

protocol EmployeesInvoicesViewPresentable {

    typealias Input = (
        periodOfIssueTrigger: Driver<Date>,
        invoiceStateTrigger: Driver<InvoiceState>,
        refreshTrigger: Driver<Void>,
        loadNextPageTrigger: Driver<Void>,
        loadingTrigger: Driver<Void>,
        invoiceChanged: Driver<Invoice>
    )

    typealias Output = (
        invoices: Driver<[InvoiceItemsSection]>,
        isLoading: Driver<Bool>,
        isRefreshing: Driver<Bool>,
        isLoadingMore: Driver<Bool>,
        errorOccured: Driver<Error>
    )

    typealias ViewModelBuilder = (EmployeesInvoicesViewPresentable.Input) -> EmployeesInvoicesViewPresentable

    var input: Input { get }
    var output: Output { get }

}

class EmployeesInvoicesViewModel: EmployeesInvoicesViewPresentable{

    var input: Input
    var output: Output
    private let api: InvoicesAPI
    private let bag = DisposeBag()

    typealias State = (invoices: BehaviorRelay<[Invoice]>,
                       isRefreshing: PublishRelay<Bool>,
                       isLoadingMore: PublishRelay<Bool>,
                       isLoading: BehaviorRelay<Bool>,
                       errorOccured: PublishRelay<Error>)
    private let state: State = (invoices: BehaviorRelay<[Invoice]>(value: []),
                                isRefreshing: PublishRelay<Bool>(),
                                isLoadingMore: PublishRelay<Bool>(),
                                isLoading: BehaviorRelay<Bool>(value: false),
                                errorOccured: PublishRelay<Error>())

    init(input: EmployeesInvoicesViewPresentable.Input, api: InvoicesAPI){
        self.input = input
        self.output = EmployeesInvoicesViewModel.output(state: self.state)
        self.api = api
        self.processInput()
    }

}

private extension EmployeesInvoicesViewModel {

    func processInput() {
        let source = PaginationWithFiltersUISource(refresh: Observable.merge(self.input.refreshTrigger.asObservable(), self.input.loadingTrigger.asObservable()),
                                                  loadNextPage: self.input.loadNextPageTrigger.asObservable(),
                                                  periodOfIssue: self.input.periodOfIssueTrigger.startWith(Date()).asObservable(),
                                                  state: self.input.invoiceStateTrigger.startWith(InvoiceState.waiting).asObservable())
        let sink = PaginationWithFiltersSink(uiSource: source, loadData: ({[load] in
            return load($0, $1, $2)
        }) )

        input.refreshTrigger.drive {[state] _ in
            state.isRefreshing.accept(true)
        }.disposed(by: bag)
        input.loadNextPageTrigger.drive {[state] _ in
            state.isLoadingMore.accept(true)
        }.disposed(by: bag)
        input.loadingTrigger.drive {[state] _ in
            state.isLoading.accept(true)
        }.disposed(by: bag)
        input.periodOfIssueTrigger.drive {[state] _ in
            state.isLoading.accept(true)
        }.disposed(by: bag)
        input.invoiceStateTrigger.drive {[state] _ in
            state.isLoading.accept(true)
        }.disposed(by: bag)

        sink.isLoading.filter{!$0}.bind {[state] _ in
            state.isLoading.accept(false)
            state.isRefreshing.accept(false)
            state.isLoadingMore.accept(false)
        }.disposed(by: bag)
        sink.elements.bind(to: state.invoices)
            .disposed(by: bag)
        sink.error.bind(to: state.errorOccured)
            .disposed(by: bag)

        input.invoiceChanged.drive { (item) in
            let list = self.state.invoices.value
            self.state.invoices.accept(list.filter{$0.id != item.id})
        }.disposed(by: bag)
    }

    func load(page: Int, periodOfIssue: Date, state: InvoiceState) -> Observable<InvoicesResponse> {
        return self.api.fetch(page: page, userId: nil, periodOfIssue: periodOfIssue, state: state)
            .asObservable()
    }

    static func output(state: State) -> EmployeesInvoicesViewPresentable.Output {
        let sections = state.invoices
            .map({
                $0.compactMap({
                    EmployeeInvoiceViewModel(withInvoice: $0)
                })
            })
            .map({[InvoiceItemsSection(model: 0, items: $0)]})
            .asDriver(onErrorJustReturn: [])
        return (
            invoices: sections,
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false),
            isRefreshing: state.isRefreshing.asDriver(onErrorJustReturn: false),
            isLoadingMore: state.isLoadingMore.asDriver(onErrorJustReturn: false),
            errorOccured: state.errorOccured.asDriver(onErrorRecover: {
                .just($0)
            })
        )
    }
}
