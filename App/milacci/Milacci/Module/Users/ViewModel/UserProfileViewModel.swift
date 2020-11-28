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
    typealias EditableInput = (hourRateEditTrigger: Driver<Void>, personalInfoEditTrigger: Driver<Void>)
    typealias Output = (
        upcommingRate: Driver<String>,
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

    typealias ViewModelBuilder = (Input, EditableInput) -> UserProfileViewPresentable
    var input: Input {get}
    var editableInput: EditableInput? {get}
    var output: Output {get}

}

class EditableUserProfileViewModel: UserProfileViewModel {

    typealias HourRateRoutingAction = PublishRelay<UserDetail>
    let hourRateRouter: HourRateRoutingAction = PublishRelay()

    typealias PersonalInfoRoutingAction = PublishRelay<UserDetail>
    let personalInfoRouter: PersonalInfoRoutingAction = PublishRelay()

    init(input: UserProfileViewPresentable.Input, editableInput: UserProfileViewPresentable.EditableInput, dependencies: UserProfileViewPresentable.Dependencies) {
        super.init(input: input, dependencies: dependencies)
        self.editableInput = editableInput

        self.editableInput?.hourRateEditTrigger.asObservable()
            .withLatestFrom(state.userDetail){
                $1
            }.subscribe(onNext: {[hourRateRouter] (userDetail) in
                if let userDetail = userDetail {
                    hourRateRouter.accept(userDetail)
                }
            }).disposed(by: bag)

        self.editableInput?.personalInfoEditTrigger.asObservable()
            .withLatestFrom(state.userDetail){
                $1
            }.subscribe(onNext: {[personalInfoRouter] (userDetail) in
                if let userDetail = userDetail {
                    personalInfoRouter.accept(userDetail)
                }
            }).disposed(by: bag)

    }
}

class UserProfileViewModel: UserProfileViewPresentable {

    private static let EMPTY_SYMBOL = "-"

    var input: UserProfileViewPresentable.Input
    var editableInput: UserProfileViewPresentable.EditableInput? = nil
    var output: UserProfileViewPresentable.Output
    typealias State = (userDetail: BehaviorRelay<UserDetail?>, error: PublishRelay<Error>,
                       isLoading: PublishRelay<Bool>)
    let state: State = (userDetail: BehaviorRelay(value: nil), error: PublishRelay(),
                        isLoading: PublishRelay())
    let bag = DisposeBag()
    let api: UserAPI
    let userIdProvider: UserProfileViewPresentable.UserIdProvider

    init(input: UserProfileViewPresentable.Input, dependencies: UserProfileViewPresentable.Dependencies) {
        self.input = input
        self.output = UserProfileViewModel.output(dependencies: dependencies, state: state)
        self.api = dependencies.api
        self.userIdProvider = dependencies.userIdProvider

        self.input.signOut.drive(onNext: { _ in
            GIDSignIn.sharedInstance()?.disconnect()
        }).disposed(by: bag)

        self.input.refresh.drive(onNext: { [weak self] _ in
            self?.refresh()
        }).disposed(by: bag)

        if let userDetail = dependencies.userDetail {
            self.state.userDetail.accept(userDetail)
        } else {
            self.load(api: dependencies.api, userIdProvider: dependencies.userIdProvider)
        }
    }

    func refresh() {
        self.load(api: api, userIdProvider: userIdProvider)
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

        let upcommingRate = userDetail
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
        let hourlyRate = userDetail
            .map { (userDetail) in
                (try? userDetail.currentHourRate()?.value.toCzechCrowns) ?? EMPTY_SYMBOL
            }
            .asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let degree = userDetail
            .map { (userDetail) in
                return UserProfileViewModel.valueOrEmpty(value: userDetail.degree)
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let name = userDetail
            .map { (userDetail) in
                "\(userDetail.name ?? "") \(userDetail.surname ?? "")"
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let jobTitle = userDetail
            .map { (userDetail) in
                userDetail.jobTitle?.description ?? EMPTY_SYMBOL
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let dateOfBirth = userDetail
            .map { (userDetail) in
                guard let date = userDetail.dateOfBirth?.universalDate else {return EMPTY_SYMBOL}
                return date.localFormat
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
                return UserProfileViewModel.valueOrEmpty(value: userDetail.phoneNumber)
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let contactEmail = userDetail
            .map { (userDetail) in
                return UserProfileViewModel.valueOrEmpty(value: userDetail.contactEmail)
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        let workType = userDetail
            .map { (userDetail) in
                userDetail.workType?.description ?? EMPTY_SYMBOL
            }.asDriver(onErrorJustReturn: EMPTY_SYMBOL)
        return (
            upcommingRate: upcommingRate,
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

    static func valueOrEmpty(value: String?) -> String {
        if let value = value,
           !value.isEmpty {
            return value
        } else {
            return EMPTY_SYMBOL
        }
    }

}
