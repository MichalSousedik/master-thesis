//
//  WageViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 06/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//
import RxSwift
import RxCocoa

protocol WageChartViewPresentable {

    typealias Input = (refresh: Driver<Void>, ())
    typealias Output = (
        invoiceChartEntries: Driver<[Invoice]>,
        error: Driver<Error>,
        isLoading: Driver<Bool>

    )

    typealias UserIdProvider = (() -> Int)
    typealias Dependencies = (api: InvoicesAPI, userIdProvider: UserIdProvider)

    typealias ViewModelBuilder = (Input) -> WageChartViewPresentable
    var input: Input {get}
    var output: Output {get}

}

class WageChartViewModel: WageChartViewPresentable {

    var input: WageChartViewPresentable.Input
    var output: WageChartViewPresentable.Output
    typealias State = (invoices: BehaviorRelay<[Invoice]>,
                       pages: BehaviorRelay<[Invoice]>,
                       error: PublishRelay<Error>,
                       isLoading: BehaviorRelay<Bool>)
    private let state: State = (invoices: BehaviorRelay(value: []),
                                pages: BehaviorRelay(value: []),
                                error: PublishRelay(),
                                isLoading: BehaviorRelay(value: false))
    private let bag = DisposeBag()

    init(input: WageChartViewPresentable.Input, dependencies: WageChartViewPresentable.Dependencies) {
        self.input = input
        self.output = WageChartViewModel.output(dependencies: dependencies, state: state)

        self.input.refresh.drive(onNext: { [weak self, dependencies] _ in
            self?.load(api: dependencies.api, userIdProvider: dependencies.userIdProvider, page: 1)
        }).disposed(by: bag)

        self.load(api: dependencies.api, userIdProvider: dependencies.userIdProvider, page: 1)
    }

}

private extension WageChartViewModel {

    func load(api: InvoicesAPI, userIdProvider: @escaping UserProfileViewPresentable.UserIdProvider, page: Int){
        self.state.isLoading.accept(true)
        api.fetchInvoices(page: page, userId: userIdProvider())
            .subscribe { [state] (invoices) in
                state.pages.accept(state.pages.value + invoices)
                state.isLoading.accept(false)
                if invoices.count > 0 {
                    self.load(api: api, userIdProvider: userIdProvider, page: page+1)
                } else {
                    state.invoices.accept(state.pages.value)
                }
            } onError: { [state] (error) in
                state.error.accept(error)
                state.isLoading.accept(false)
            }.disposed(by: bag)

    }

}

private extension WageChartViewModel {

    static func output(dependencies: WageChartViewPresentable.Dependencies, state: State) -> WageChartViewPresentable.Output {
        return (
            invoiceChartEntries: state.invoices.asDriver(onErrorJustReturn: []),
            error: state.error.asDriver(onErrorDriveWith: .empty()),
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false)
        )

    }

}
