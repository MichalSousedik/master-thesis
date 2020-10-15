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
import RxDataSources

protocol InvoicesViewPresentable {
    
    typealias Input = (
        invoiceSelect: Driver<InvoiceViewModel>,
        refreshTrigger: Driver<Void>,
        loadNextPageTrigger: Driver<Void>
    )
    
    typealias Output = (
        invoices: Driver<[InvoiceItemsSection]>,
        isLoading: Driver<Bool>
    )
    
    typealias ViewModelBuilder = (InvoicesViewPresentable.Input) -> InvoicesViewPresentable
    
    var input: Input { get }
    var output: Output { get }
    
}

class InvoicesViewModel : InvoicesViewPresentable{
    
    var input: Input
    var output: Output
    private let api: InvoicesAPI
    private let bag = DisposeBag()
    
    typealias State = (invoices: BehaviorRelay<[Invoice]>,
                       isLoading: PublishRelay<Bool>)
    private let state: State = (invoices: BehaviorRelay<[Invoice]>(value: []),
                                isLoading: PublishRelay<Bool>())
    
    typealias RoutingAction = PublishRelay<Invoice>
    private let router: RoutingAction = PublishRelay()
    typealias Routing = Driver<Invoice>
    lazy var routing: Routing = router.asDriver(onErrorDriveWith: .empty())
    
    init(input: InvoicesViewPresentable.Input, api: InvoicesAPI){
        self.input = input
        self.output = InvoicesViewModel.output(state: self.state)
        self.api = api
        self.processInput()
    }
    
}

private extension InvoicesViewModel {
    
   func processInput() {
    self.input.invoiceSelect
        .map { [router] in
            router.accept($0.invoice)
        }
    .drive()
    .disposed(by: bag)
    
    let source = PaginationUISource(refresh: self.input.refreshTrigger.asObservable(),
                                    loadNextPage: self.input.loadNextPageTrigger.asObservable())
    let sink = PaginationSink(ui: source, loadData: load(page: ))

    sink.isLoading.bind(to: state.isLoading)
        .disposed(by: bag)
    sink.elements.bind(to: state.invoices)
        .disposed(by: bag)
    }
    
    func load(page: Int) -> Observable<InvoicesResponse> {
        return self.api.fetchInvoices(userId: 1, page: page)
            .asObservable()
    }
    
    static func output(state: State) -> InvoicesViewPresentable.Output {
        let sections = state.invoices.asObservable()
            .map({
                $0.compactMap({
                   InvoiceViewModel(withInvoice: $0)
                })
            })
        .map({[InvoiceItemsSection(model: 0, items: $0)]})
        .asDriver(onErrorJustReturn: [])
        return (
            invoices: sections,
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false)
        )
    }
}
