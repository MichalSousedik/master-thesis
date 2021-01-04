//
//  PaginationNetworkLogic.swift
//  Milacci
//
//  Created by Michal Sousedik on 13/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift

struct PaginationUISource {
    /// reloads first page and dumps all other cached pages.
    let refresh: Observable<Void>
    /// loads next page
    let loadNextPage: Observable<Void>
}

struct PaginationSink<T> {
    /// true if network loading is in progress.
    let isLoading: Observable<Bool>
    /// elements from all loaded pages
    let elements: Observable<[T]>
    /// fires once for each error
    let error: Observable<Error>
}

extension PaginationSink {

    init(uiSource: PaginationUISource, loadData: @escaping (Int) -> Observable<[T]>) {
        let loadResults = BehaviorSubject<[Int: [T]]>(value: [:])

        let currentPageNumber = loadResults
            .map { $0.keys }
            .map { $0.max() ?? 1 }

        let reload = uiSource.refresh
            .map { -1 }

        let loadNext = uiSource.loadNextPage
            .withLatestFrom(currentPageNumber)
            .map { $0 + 1 }

        let start = Observable.merge(reload, loadNext, .just(-1))

        let page = start
            .flatMap { page in
                Observable.combineLatest(Observable.just(page), loadData(page == -1 ? 1 : page)){
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
