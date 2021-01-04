//
//  InvoicesViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import RxRelay
import RxCocoa

protocol InvoicesViewPresentable {

    typealias Input = (
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

    typealias ViewModelBuilder = (InvoicesViewPresentable.Input) -> InvoicesViewPresentable

    var input: Input { get }
    var output: Output { get }

}

class InvoicesViewModel: InvoicesViewPresentable{

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

    init(input: InvoicesViewPresentable.Input, api: InvoicesAPI){
        self.input = input
        self.output = InvoicesViewModel.output(state: self.state)
        self.api = api
        self.processInput()
    }

}

private extension InvoicesViewModel {

    func processInput() {
        let source = PaginationUISource(
            refresh: Observable.merge(
                self.input.refreshTrigger.asObservable(),
                self.input.loadingTrigger.asObservable()
            ),
            loadNextPage: self.input.loadNextPageTrigger.asObservable())
        let sink = PaginationSink(uiSource: source, loadData: load(page: ))

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
        sink.elements.bind(to: state.invoices)
            .disposed(by: bag)
        sink.error.bind(to: state.errorOccured)
            .disposed(by: bag)

        input.invoiceChanged.drive { (item) in
            var list = self.state.invoices.value
            if let index = list.firstIndex(where: { invoice in
                return invoice.id == item.id
            }) {
                list[index] = item
            }
            self.state.invoices.accept(list)
        }.disposed(by: bag)
    }

    func load(page: Int) -> Observable<InvoicesResponse> {
        return self.api.fetch(page: page, userId: UserSettingsService.shared.userId, periodOfIssue: nil, state: nil)
            .asObservable()
    }

    static func output(state: State) -> EmployeesInvoicesViewPresentable.Output {
        let sections = state.invoices
            .map({
                $0.compactMap({
                    MyInvoiceViewModel(withInvoice: $0)
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

