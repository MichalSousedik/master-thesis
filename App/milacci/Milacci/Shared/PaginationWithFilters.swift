//
//  PaginationWithFilters.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift

struct PaginationWithFiltersUISource {
    /// reloads first page and dumps all other cached pages.
    let refresh: Observable<Void>
    /// loads next page
    let loadNextPage: Observable<Void>

    let periodOfIssue: Observable<Date>
    let state: Observable<InvoiceState>
}

struct PaginationWithFiltersSink<T> {
    /// true if network loading is in progress.
    let isLoading: Observable<Bool>
    /// elements from all loaded pages
    let elements: Observable<[T]>
    /// fires once for each error
    let error: Observable<Error>
}

extension PaginationWithFiltersSink {

    init(uiSource: PaginationWithFiltersUISource, loadData: @escaping (Int, Date, InvoiceState) -> Observable<[T]>) {
        let loadResults = BehaviorSubject<[Int: [T]]>(value: [:])

        let periodOfIssueTrigger = uiSource.periodOfIssue
            .withLatestFrom(uiSource.state) { (periodOfIssue, state) in
                return (page: -1, periodOfIssue: periodOfIssue, state: state)
            }

        let stateTrigger = uiSource.state
            .withLatestFrom(uiSource.periodOfIssue) { (state, periodOfIssue) in
                return (page: -1, periodOfIssue: periodOfIssue, state: state)
            }

        let maxPage = loadResults
            .map { $0.keys }
            .map { $0.max() ?? 1 }

        let reload = uiSource.refresh
            .withLatestFrom(uiSource.state) { (page, state) in
                return (page: -1, state: state)
            }.withLatestFrom(uiSource.periodOfIssue) { (complex, periodOfIssue) in
                return (page: complex.page, periodOfIssue: periodOfIssue, state: complex.state)
            }

        let loadNext = uiSource.loadNextPage
            .withLatestFrom(maxPage)
            .withLatestFrom(uiSource.state) { (page, state) in
                return (page: page, state: state)
            }.withLatestFrom(uiSource.periodOfIssue) { (complex, periodOfIssue) in
                return (page: complex.page, periodOfIssue: periodOfIssue, state: complex.state)
            }
            .map { (page: $0 + 1, periodOfIssue: $1, state: $2) }

            let start = Observable.merge(reload, loadNext, stateTrigger, periodOfIssueTrigger)

        let page = start
            .map({ (page: Int, periodOfIssue: Date, state: InvoiceState) in
                return (page, periodOfIssue, state)
            })
            .flatMap { (page, periodOfIssue, state) in
                Observable.combineLatest(Observable.just(page), loadData(page == -1 ? 1 : page, periodOfIssue, state)){
                    (pageNumber: $0, items: $1)

                }
                    .materialize()
                    .filter { $0.isCompleted == false }
            }
            .share()

        _ = page
            .compactMap { $0.element }
            .withLatestFrom(loadResults) { (pages: $1, newPage: $0) }
            .filter { $0.newPage.pageNumber == -1 || !$0.newPage.items.isEmpty }
            .map { $0.newPage.pageNumber == -1 ? [1: $0.newPage.items] : $0.pages.merging([$0.newPage],
                                                                                          uniquingKeysWith: { $1 }) }
            .subscribe(loadResults)

        let isLoading = Observable.merge(start.map { _ in 1 }, page.map { _ in -1 })
            .scan(0, accumulator: +)
            .map { $0 > 0 }
            .distinctUntilChanged()

        let elements = loadResults
            .map { $0.sorted(by: { $0.key < $1.key }).flatMap { $0.value } }

        let error = page
            .map { $0.error }
            .compactMap{$0}

        self.isLoading = isLoading
        self.elements = elements
        self.error = error
    }
}
