//
//  TableViewRxReachedBottom.swift
//  Milacci
//
//  Created by Michal Sousedik on 11/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//
import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {

    var reachedBottom: Driver<Void> {
        return contentOffset
            .flatMap { [weak base] contentOffset -> Observable<CGFloat> in
                guard let scrollView = base else {
                    return Observable.empty()
                }

                let visibleHeight = scrollView.frame.height
                    - scrollView.contentInset.top
                    - scrollView.contentInset.bottom
                let yPosition = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return yPosition > threshold ? Observable.just(scrollView.contentSize.height) : Observable.empty()
            }
            .distinctUntilChanged()
            .map { _ in }
            .asDriver(onErrorDriveWith: .empty())
    }

    func reached(reset: Observable<Void>) -> Driver<Void> {
        return Observable.of(reset, (contentOffset
            .flatMap { [weak base] contentOffset -> Observable<CGFloat> in
                guard let scrollView = base else {
                    return Observable.empty()
                }

                let visibleHeight = scrollView.frame.height
                    - scrollView.contentInset.top
                    - scrollView.contentInset.bottom
                let yPosition = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return yPosition > threshold ? Observable.just(scrollView.contentSize.height) : Observable.empty()
            }
                    .distinctUntilChanged()
                    .map { _ in }))
            .merge()
            .asDriver(onErrorDriveWith: .empty())
    }

}
