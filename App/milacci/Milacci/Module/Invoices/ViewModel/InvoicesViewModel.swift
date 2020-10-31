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
import Alamofire

protocol InvoicesViewPresentable {

    typealias Uploading = (
        isUploading: Bool,
        forInvoice: Invoice?
    )

    typealias Input = (
        invoiceSelect: Driver<InvoiceViewModel>,
        refreshTrigger: Driver<Void>,
        loadNextPageTrigger: Driver<Void>,
        filePick: Driver<URL>
    )

    typealias Output = (
        invoices: Driver<[InvoiceItemsSection]>,
        isLoading: Driver<Bool>,
        errorOccured: Driver<Error>,
        pickFile: Driver<Void>,
        showUrl: Driver<URL>,
        isUploadingFile: Driver<Uploading>
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
                       isLoading: PublishRelay<Bool>,
                       errorOccured: PublishRelay<Error>,
                       pickFile: PublishSubject<Void>,
                       fileToBeDisplayed: PublishSubject<URL>,
                       isUploadingInvoice: PublishSubject<Uploading>)
    private let state: State = (invoices: BehaviorRelay<[Invoice]>(value: []),
                                isLoading: PublishRelay<Bool>(),
                                errorOccured: PublishRelay<Error>(),
                                pickFile: PublishSubject<Void>(),
                                fileToBeDisplayed: PublishSubject<URL>(),
                                isUploadingInvoice: PublishSubject<Uploading>())

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
            .map { [api, state] in
                if $0.isFilePresent {
                    api.fetchInvoice(id: $0.invoice.id).subscribe(onSuccess: { [state] (invoice) in
                        if let filename = invoice.filename,
                           let url = URL(string: filename) {
                            state.fileToBeDisplayed.onNext(url)
                        }
                    }, onError: { (error) in
                        state.errorOccured.accept(error)
                    }).disposed(by: self.bag)
                } else {
                    state.pickFile.onNext(())
                }
            }
            .drive()
            .disposed(by: bag)

        self.input.filePick
            .withLatestFrom(self.input.invoiceSelect) { (url, invoiceViewModel) in
                self.state.isUploadingInvoice.onNext(
                    (isUploading: true, forInvoice: invoiceViewModel.invoice)
                )
                self.api.uploadFile(id: invoiceViewModel.invoice.id, url: url)
                    .subscribe { (fileUrl) in
                        var list = self.state.invoices.value
                        if let index = list.firstIndex(where: { invoice in
                            return invoice.id == invoiceViewModel.invoice.id
                        }) {
                            list[index].filename = fileUrl
                            print(fileUrl)
                        }
                        self.state.invoices.accept(list)
                        self.state.isUploadingInvoice.onNext(
                            (isUploading: false, forInvoice: nil)
                        )
                    } onError: { (error) in
                        self.state.errorOccured.accept(error)
                        self.state.isUploadingInvoice.onNext(
                            (isUploading: false, forInvoice: nil)
                        )

                    }.disposed(by: self.bag)
            }.drive()
            .disposed(by: bag)

        let source = PaginationUISource(refresh: self.input.refreshTrigger.asObservable(),
                                        loadNextPage: self.input.loadNextPageTrigger.asObservable())
        let sink = PaginationSink(uiSource: source, loadData: load(page: ))

        sink.isLoading.bind(to: state.isLoading)
            .disposed(by: bag)
        sink.elements.bind(to: state.invoices)
            .disposed(by: bag)
        sink.error.bind(to: state.errorOccured)
            .disposed(by: bag)
    }

    func load(page: Int) -> Observable<InvoicesResponse> {
        return self.api.fetchInvoices(page: page)
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
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false),
            errorOccured: state.errorOccured.asDriver(onErrorRecover: {
                .just($0)
            }),
            pickFile: state.pickFile.asDriver(onErrorDriveWith: .empty()),
            showUrl: state.fileToBeDisplayed.asDriver(onErrorDriveWith: .empty()),
            isUploadingFile: state.isUploadingInvoice.asDriver(onErrorJustReturn:
                                                                (isUploading: false, forInvoice: nil))
        )
    }
}
