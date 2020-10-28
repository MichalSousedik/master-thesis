//
//  InvoiceDetailViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import RxRelay
import RxCocoa

protocol InvoiceDetailViewPresentable {
    
    typealias Input = ()
    typealias Output = (date: Driver<String>,
        value: Driver<String>,
        state: Driver<String>,
        hours:Driver<String>,
        hourlyWage:Driver<String>,
        fileName: Driver<String?>)
    typealias Dependencies = (invoice: Invoice, ())
    
    typealias ViewModelBuilder = (InvoiceDetailViewPresentable.Input) -> InvoiceDetailViewPresentable
    
    var output: InvoiceDetailViewPresentable.Output { get }
    var input: InvoiceDetailViewPresentable.Input { get }
    
    func refreshState()
    
}

class InvoiceDetailViewModel: InvoiceDetailViewPresentable {
    
    typealias State = (invoice: PublishRelay<Invoice>, ())
    
    var output: InvoiceDetailViewPresentable.Output
    var input: InvoiceDetailViewPresentable.Input
    private let state: State = (invoice: PublishRelay(), ())
    private let api: InvoicesAPI
    private let bag = DisposeBag()
    private let id: Int
    
    init(input: InvoiceDetailViewPresentable.Input, dependencies: Dependencies, api: InvoicesAPI) {
        self.input = input
        self.output = InvoiceDetailViewModel.output(dependencies: dependencies, state: state)
        self.api = api
        self.id = dependencies.invoice.id
        self.refreshState()
    }
    
    func refreshState() {
        self.processState(withId: id)
    }
    
    
}

private extension InvoiceDetailViewModel {
    
    func processState(withId id: Int) -> Void {
        self.api
            .fetchInvoice(id: id)
            .map({ [state] in
                state.invoice.accept($0)
            })
            .subscribe()
            .disposed(by: bag)
    }
    
    static func output(dependencies: Dependencies, state: State) -> InvoiceDetailViewPresentable.Output {
        let invoice = dependencies.invoice
        let hours = state.invoice.asObservable()
            .map({ _ in
                ""
//                "\($0.hours ?? 0)"
            })
            .asDriver(onErrorJustReturn: "")
        let hourlyWage = state.invoice.asObservable()
            .map({_ in
                ""
//                "\($0.hourlyWage?.toCzechCrowns ?? "")"
            })
            .asDriver(onErrorJustReturn: "")
        let fileName = state.invoice.asObservable()
            .map({
                $0.filename
            })
            .startWith(invoice.filename)
            .asDriver(onErrorJustReturn: nil)
        return (
            date: .just(invoice.periodOfIssue),
            value: .just(""),//Int(invoice.value).toCzechCrowns)
            state: .just(invoice.state.description),
            hours: hours,
            hourlyWage: hourlyWage,
            fileName: fileName
        )
    }
    
}
