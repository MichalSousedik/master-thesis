//
//  EditHourlyRateViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 17/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import RxRelay
import RxCocoa

protocol EditHourlyRateViewPresentable {

    typealias SaveHourRate = (value: Double, since: Date)

    typealias Input = (
        saveTrigger: Driver<SaveHourRate>,
        ()
    )

    typealias Output = (
        currentHourlyRate: Driver<Double?>,
        since: Driver<Date>,
        isLoading: Driver<Bool>,
        errorOccured: Driver<Error>
    )

    typealias Dependencies = (api: HourRateAPI, userDetail: UserDetail)
    typealias ViewModelBuilder = (EditHourlyRateViewPresentable.Input) -> EditHourlyRateViewPresentable

    var input: Input { get }
    var output: Output { get }

}

class EditHourlyRateViewModel: EditHourlyRateViewPresentable{

    var input: Input
    var output: Output
    let api: HourRateAPI
    let userDetail: UserDetail
    private let bag = DisposeBag()

    typealias State = (currentHourlyRate: BehaviorRelay<Double?>,
                       since: BehaviorRelay<Date>,
                       isLoading: PublishRelay<Bool>,
                       error: PublishRelay<Error>)
    private let state: State = (currentHourlyRate: BehaviorRelay<Double?>(value: nil),
                                since: BehaviorRelay<Date>(value: Date()),
                                isLoading: PublishRelay<Bool>(),
                                error: PublishRelay<Error>())

    typealias RoutingAction = PublishRelay<HourRate>
    let router: RoutingAction = PublishRelay()

    init(input: EditHourlyRateViewPresentable.Input, dependecies: EditHourlyRateViewPresentable.Dependencies){
        self.input = input
        self.output = EditHourlyRateViewModel.output(state: self.state)
        self.api = dependecies.api
        self.userDetail = dependecies.userDetail
        self.processUserDetail(detail: dependecies.userDetail)
        self.processInput()
    }

}

private extension EditHourlyRateViewModel {

    func processUserDetail(detail: UserDetail){
        self.state.currentHourlyRate.accept((try? detail.currentHourRate())?.value)

        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        var dateComponents: DateComponents? = calendar.dateComponents([.year, .month, .day], from: nextMonth)

        dateComponents?.day = 1

        if let dateComponents = dateComponents,
           let date = calendar.date(from: dateComponents){
            self.state.since.accept(date)
        }
    }

    func processInput() {
        self.input.saveTrigger.drive {[api, state, userDetail, bag, router] (value: Double, since: Date) in
            state.isLoading.accept(true)
            api.create(value: value, since: since, userId: userDetail.id)
                .subscribe { [router, state] (hourRate) in
                    router.accept(hourRate)
                    state.isLoading.accept(false)
                } onError: { [state] (error) in
                    state.error.accept(error)
                    state.isLoading.accept(false)
                }.disposed(by: bag)
        }.disposed(by: bag)
    }

    static func output(state: State) -> EditHourlyRateViewPresentable.Output {
        return (
            currentHourlyRate: state.currentHourlyRate.asDriver(onErrorJustReturn: 0),
            since: state.since.asDriver(onErrorJustReturn: Date()),
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false),
            errorOccured: state.error.asDriver(onErrorRecover: {
                .just($0)
            })
        )
    }
}
