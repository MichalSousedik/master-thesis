//
//  PaginationNetworkLogic.swift
//  Milacci
//
//  Created by Michal Sousedik on 13/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift

struct PaginationWithSearchUISource {
    /// reloads first page and dumps all other cached pages.
    let refresh: Observable<Void>
    /// loads next page
    let loadNextPage: Observable<Void>

    let searchText: Observable<String>
}

struct PaginationWithSearchSink<T> {
    /// true if network loading is in progress.
    let isLoading: Observable<Bool>
    /// elements from all loaded pages
    let elements: Observable<[T]>
    /// fires once for each error
    let error: Observable<Error>
}

extension PaginationWithSearchSink {

    init(uiSource: PaginationWithSearchUISource, loadData: @escaping (Int, String) -> Observable<[T]>) {
        let loadResults = BehaviorSubject<[Int: [T]]>(value: [:])

        let searchTrigger = uiSource.searchText
            .map {
                (page: -1, searchText: $0)
            }

        let maxPage = loadResults
            .map { $0.keys }
            .map { $0.max() ?? 1 }

        let reload = uiSource.refresh
            .withLatestFrom(uiSource.searchText) { (page, searchText) in
                return searchText
            }.map { (searchText) in
                return (page: -1, searchText: searchText)
            }

        let loadNext = uiSource.loadNextPage
            .withLatestFrom(maxPage)
            .withLatestFrom(uiSource.searchText) { (page, searchText) in
                return (page, searchText)
            }.map { (page, searchText) in
                return (page: page, searchText: searchText)
            }
            .map { (page: $0 + 1, searchText: $1) }

                let start = Observable.merge(reload, loadNext, searchTrigger)

        let page = start
            .map({ (page: Int, searchText: String) in
                    print(page)
                    print(searchText)
                return (page, searchText)
            })
            .flatMap { (page, searchText) in
                Observable.combineLatest(Observable.just(page), loadData(page == -1 ? 1 : page, searchText)){
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
