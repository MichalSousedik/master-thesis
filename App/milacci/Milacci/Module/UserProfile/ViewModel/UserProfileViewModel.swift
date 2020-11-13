//
//  UserProfileViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 02/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import RxCocoa
import GoogleSignIn

protocol UserProfileViewPresentable {

    typealias Input = (signOut: Driver<Void>, refresh: Driver<Void>)
    typealias Output = (
        hourlyRate: Driver<String>,
        name: Driver<String>,
        jobTitle: Driver<String>,
        degree: Driver<String>,
        dayOfBirth: Driver<String>,
        hourlyCapacity: Driver<String>,
        phoneNumber: Driver<String>,
        email: Driver<String>,
        workType: Driver<String>,
        error: Driver<Error>,
        isLoading: Driver<Bool>

    )

    typealias UserIdProvider = (() -> Int)
    typealias Dependencies = (api: UserAPI, userIdProvider: UserIdProvider, userDetail: UserDetail?)

    typealias ViewModelBuilder = (Input) -> UserProfileViewPresentable
    var input: Input {get}
    var output: Output {get}

}

class UserProfileViewModel: UserProfileViewPresentable {

    private static let EMPTY_SYMBOL = "-"

    var input: UserProfileViewPresentable.Input
    var output: UserProfileViewPresentable.Output
    typealias State = (userDetail: BehaviorRelay<UserDetail?>, error: PublishRelay<Error>,
                       isLoading: PublishRelay<Bool>)
    private let state: State = (userDetail: BehaviorRelay(value: nil), error: PublishRelay(),
                                isLoading: PublishRelay())
    private let bag = DisposeBag()

    init(input: UserProfileViewPresentable.Input, dependencies: UserProfileViewPresentable.Dependencies) {
        self.input = input
        self.output = UserProfileViewModel.output(dependencies: dependencies, state: state)

        self.input.signOut.drive(onNext: { _ in
            GIDSignIn.sharedInstance()?.disconnect()
        }).disposed(by: bag)

        self.input.refresh.drive(onNext: { [weak self, dependencies] _ in
            self?.load(api: dependencies.api, userIdProvider: dependencies.userIdProvider)
        }).disposed(by: bag)

        if let userDetail = dependencies.userDetail {
            self.state.userDetail.accept(userDetail)
        } else {
            self.load(api: dependencies.api, userIdProvider: dependencies.userIdProvider)
        }
    }

}

private extension UserProfileViewModel {

    func load(api: UserAPI, userIdProvider: UserIdProvider){
        self.state.isLoading.accept(true)
        api.fetchDetail(id: userIdProvider())
            .subscribe { [state] (userDetail) in
                state.userDetail.accept(userDetail)
                state.isLoading.accept(false)
            } onError: { [state] (error) in
                state.error.accept(error)
                state.isLoading.accept(false)
            }.disposed(by: bag)

    }

}

private extension UserProfileViewModel {

    static func output(dependencies: UserProfileViewPresentable.Dependencies, state: State) -> UserProfileViewPresentable.Output {
        let userDetail = state.userDetail.asObservable()
            .compactMap{$0}
        let hourlyRate = userDetail
            .map { (userDetail) in
                (try? userDetail.currentHourRate()?.value.toCzechCrowns) ?? EMPTY_SYMBOL
            }
            .asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let degree = userDetail
            .map { (userDetail) in
                userDetail.degree ?? EMPTY_SYMBOL
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let name = userDetail
            .map { (userDetail) in
                "\(userDetail.name) \(userDetail.surname)"
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let jobTitle = userDetail
            .map { (userDetail) in
                userDetail.jobTitle?.description ?? EMPTY_SYMBOL
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let dateOfBirth = userDetail
            .map { (userDetail) in
                guard let date = userDetail.dateOfBirth?.universalDate else {return EMPTY_SYMBOL}
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd. MM. yyyy"
                return dateFormatterPrint.string(from: date)
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let hourlyCapacity = userDetail
            .map { (userDetail) in
                if let cap = userDetail.hourlyCapacity {
                    return String(cap)
                } else {
                    return EMPTY_SYMBOL
                }
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let phoneNumber = userDetail
            .map { (userDetail) in
                userDetail.phoneNumber ?? EMPTY_SYMBOL
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let contactEmail = userDetail
            .map { (userDetail) in
                userDetail.contactEmail ?? EMPTY_SYMBOL
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let workType = userDetail
            .map { (userDetail) in
                userDetail.workType?.description ?? EMPTY_SYMBOL
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        return (
            hourlyRate: hourlyRate,
            name: name,
            jobTitle: jobTitle,
            degree: degree,
            dayOfBirth: dateOfBirth,
            hourlyCapacity: hourlyCapacity,
            phoneNumber: phoneNumber,
            email: contactEmail,
            workType: workType,
            error: state.error.asDriver(onErrorDriveWith: .empty()),
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false)
        )

    }

}
