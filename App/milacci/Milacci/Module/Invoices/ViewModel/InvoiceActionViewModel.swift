//
//  InvoiceActionViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import RxRelay
import RxCocoa

protocol InvoiceActionViewPresentable {

    typealias InvoiceProcessing = (
        isProcessing: Bool,
        invoice: Invoice?
    )

    typealias Input = (
        invoiceSelect: Driver<InvoiceViewModel>,
        invoiceActionTrigger: Driver<Invoice>,
        filePick: Driver<URL>
    )

    typealias Output = (
        errorOccured: Driver<Error>,
        pickFile: Driver<Void>,
        showUrl: Driver<URL>,
        isProcessingInvoice: Driver<InvoiceProcessing>,
        info: Driver<String>,
        invoiceChanged: Driver<Invoice>
    )

    typealias ViewModelBuilder = (InvoiceActionViewPresentable.Input) -> InvoiceActionViewPresentable

    var input: Input { get }
    var output: Output { get }

}
class InvoiceActionViewModel: InvoiceActionViewPresentable{
    var input: Input
    var output: Output
    var api: InvoicesAPI
    let bag = DisposeBag()

    typealias State = (errorOccured: PublishRelay<Error>,
                       pickFile: PublishSubject<Void>,
                       fileToBeDisplayed: PublishSubject<URL>,
                       isProcessingInvoice: PublishSubject<InvoiceProcessing>,
                       info: PublishRelay<String>,
                       changedInvoice: PublishRelay<Invoice>)
    private let state: State = (errorOccured: PublishRelay<Error>(),
                                pickFile: PublishSubject<Void>(),
                                fileToBeDisplayed: PublishSubject<URL>(),
                                isProcessingInvoice: PublishSubject<InvoiceProcessing>(),
                                info: PublishRelay(),
                                changedInvoice: PublishRelay())

    init(input: InvoiceActionViewPresentable.Input, api: InvoicesAPI){
        self.input = input
        self.output = InvoiceActionViewModel.output(state: self.state)
        self.api = api
        self.processInput()
    }

}

private extension InvoiceActionViewModel {

    func processInput() {
        input.invoiceActionTrigger.drive {[api, state, bag] (invoice) in
            state.isProcessingInvoice.onNext((isProcessing: true, invoice: invoice))
            api.updateInvoice(invoice: invoice, url: nil)
                .subscribe { (invoice) in
                    state.isProcessingInvoice.onNext((isProcessing: false, invoice: nil))
                    state.changedInvoice.accept(invoice)
                } onError: { (error) in
                    state.isProcessingInvoice.onNext((isProcessing: false, invoice: nil))
                    state.errorOccured.accept(error)
                }.disposed(by: bag)
        }.disposed(by: bag)

        self.handleSelect()
        self.handleFilePick()
    }

    static func output(state: State) -> InvoiceActionViewPresentable.Output {
        return (
            errorOccured: state.errorOccured.asDriver(onErrorRecover: {
                .just($0)
            }),
            pickFile: state.pickFile.asDriver(onErrorDriveWith: .empty()),
            showUrl: state.fileToBeDisplayed.asDriver(onErrorDriveWith: .empty()),
            isProcessingInvoice: state.isProcessingInvoice.asDriver(onErrorJustReturn:
                                                                (isProcessing: false, invoice: nil)),
            info: state.info.asDriver(onErrorDriveWith: .empty()),
            invoiceChanged: state.changedInvoice.asDriver(onErrorDriveWith: .empty())
        )
    }

    func handleSelect(){
        self.input.invoiceSelect
            .map { [state, api, bag] in
                if let message = $0.infoMessage {
                    state.info.accept(message)
                }
                if $0.canDownloadFile {
                    state.isProcessingInvoice.onNext(
                        (isProcessing: true, invoice: $0.invoice)
                    )
                    api.fetchInvoice(id: $0.invoice.id).subscribe(onSuccess: { [state] (invoice) in
                        state.isProcessingInvoice.onNext(
                            (isProcessing: false, invoice: nil)
                        )
                        if let filename = invoice.filename,
                           let url = URL(string: filename) {
                            state.fileToBeDisplayed.onNext(url)
                        }
                    }, onError: { [state] (error) in
                        state.isProcessingInvoice.onNext(
                            (isProcessing: false, invoice: nil)
                        )
                        state.errorOccured.accept(error)
                    }).disposed(by: bag)
                } else if $0.canUploadFile {
                    state.pickFile.onNext(())
                }
            }
            .drive()
            .disposed(by: bag)
    }

    func handleFilePick() {
        self.input.filePick
            .withLatestFrom(self.input.invoiceSelect) { (url, invoiceViewModel) in
                self.state.isProcessingInvoice.onNext(
                    (isProcessing: true, invoice: invoiceViewModel.invoice)
                )
                self.api.updateInvoice(invoice: invoiceViewModel.invoice, url: url)
                    .subscribe { (item) in
                        self.state.changedInvoice.accept(item)
                        self.state.isProcessingInvoice.onNext(
                            (isProcessing: false, invoice: nil)
                        )
                    } onError: { (error) in
                        self.state.errorOccured.accept(error)
                        self.state.isProcessingInvoice.onNext(
                            (isProcessing: false, invoice: nil)
                        )

                    }.disposed(by: self.bag)
            }.drive()
            .disposed(by: bag)
    }
}
