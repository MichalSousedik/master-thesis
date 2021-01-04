//
//  HourlyRateViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//
import RxSwift
import RxCocoa

protocol HourlyRateViewPresentable {

    typealias Input = (refresh: Driver<Void>, ())
    typealias Output = (
        upcommingRate: Driver<String>,
        hourlyRate: Driver<String>,
        error: Driver<Error>,
        isLoading: Driver<Bool>
    )

    typealias UserIdProvider = (() -> Int)
    typealias Dependencies = (api: UserAPI, userIdProvider: UserIdProvider)

    typealias ViewModelBuilder = (Input) -> HourlyRateViewPresentable
    var input: Input {get}
    var output: Output {get}

}

class HourlyRateViewModel: HourlyRateViewPresentable {

    var input: HourlyRateViewPresentable.Input
    var output: HourlyRateViewPresentable.Output
    typealias State = (userDetail: PublishRelay<UserDetail>,
                       error: PublishRelay<Error>,
                       isLoading: BehaviorRelay<Bool>)
    private let state: State = (userDetail: PublishRelay(),
                                error: PublishRelay(),
                                isLoading: BehaviorRelay(value: false))
    private let bag = DisposeBag()

    init(input: HourlyRateViewPresentable.Input, dependencies: HourlyRateViewPresentable.Dependencies) {
        self.input = input
        self.output = HourlyRateViewModel.output(dependencies: dependencies, state: state)

        self.input.refresh.drive(onNext: { [weak self, dependencies] _ in
            self?.load(api: dependencies.api, userIdProvider: dependencies.userIdProvider)
        }).disposed(by: bag)
    }

}

private extension HourlyRateViewModel {

    func load(api: UserAPI, userIdProvider: @escaping UserProfileViewPresentable.UserIdProvider){
        self.state.isLoading.accept(true)
        api.detail(id: userIdProvider())
            .subscribe { [state] (userDetail) in
                state.userDetail.accept(userDetail)
                state.isLoading.accept(false)
            } onError: { [state] (error) in
                state.error.accept(error)
                state.isLoading.accept(false)
            }.disposed(by: bag)

    }

}

private extension HourlyRateViewModel {

    private static let EMPTY_SYMBOL = "-"

    static func output(dependencies: HourlyRateViewPresentable.Dependencies, state: State) -> HourlyRateViewPresentable.Output {
        let currentHourlyRate =
            Observable.of(
                state.userDetail
                    .map { (userDetail) -> HourRate? in
                        do {
                            return try userDetail.currentHourRate()
                        } catch {
                            state.error.accept(error)
                        }
                        return nil
                    }
                    .map({ (hourRate) in
                        if let hourRate = hourRate {
                            return hourRate.value.toCzechCrowns
                        } else {
                            return "-"
                        }
                    }),
                state.error.map({ _ in
                    return "-"
                }))
            .merge()
            .asDriver(onErrorJustReturn: "-")
        let upcommingRate = state.userDetail
            .map { (userDetail) in
                if let upcommingRate = try? userDetail.upcommingHourRate(),
                   let since = upcommingRate.since.universalDate {
                    let calendar = Calendar.current
                    let date1 = calendar.startOfDay(for: Date())
                    let date2 = calendar.startOfDay(for: since)

                    if let days = calendar.dateComponents([.day], from: date1, to: date2).day {
                        return "\(L10n.in) \(days) \(HourRate.dayFormat(numberOfDays: days)): \(upcommingRate.value.toCzechCrowns)"
                    }

                }
                return ""
            }
            .asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        return (
            upcommingRate: upcommingRate,
            hourlyRate: currentHourlyRate,
            error: state.error.asDriver(onErrorDriveWith: .empty()),
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false)
        )

    }

}
