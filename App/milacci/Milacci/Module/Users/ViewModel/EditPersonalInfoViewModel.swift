//
//  EditPersonalInfoViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 18/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import RxRelay
import RxCocoa

protocol EditPersonalInfoViewPresentable {

    typealias SaveUserDetail = (name: String?, surname: String?, jobTitle: JobTitle?, degree: String?, hourlyCapacity: String?, phoneNumber: String?, contactEmail: String?, workType: WorkType?)

    typealias Input = (
        saveTrigger: Driver<SaveUserDetail>,
        ()
    )

    typealias Output = (
        name: Driver<String>,
        surname: Driver<String>,
        jobTitle: Driver<JobTitle?>,
        degree: Driver<String>,
        hourlyCapacity: Driver<String>,
        phoneNumber: Driver<String>,
        contactEmail: Driver<String>,
        workType: Driver<WorkType?>,
        error: Driver<Error>,
        isLoading: Driver<Bool>
    )

    typealias Dependencies = (api: UserAPI, userDetail: UserDetail)
    typealias ViewModelBuilder = (EditPersonalInfoViewPresentable.Input) -> EditPersonalInfoViewPresentable

    var input: Input { get }
    var output: Output { get }

}

class EditPersonalInfoViewModel: EditPersonalInfoViewPresentable {

    var input: Input
    var output: Output
    let api: UserAPI
    private let bag = DisposeBag()

    typealias State = (userDetail: BehaviorRelay<UserDetail>,
                       isLoading: BehaviorRelay<Bool>,
                       error: PublishRelay<Error>)
    private let state: State = (userDetail: BehaviorRelay<UserDetail>(value: UserDetail(id: 0, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [])),
                                isLoading: BehaviorRelay<Bool>(value: false),
                                error: PublishRelay<Error>())

    typealias CompleteAction = PublishRelay<UserDetail>
    let complete: CompleteAction = PublishRelay()

    init(input: EditPersonalInfoViewPresentable.Input, dependecies: EditPersonalInfoViewPresentable.Dependencies){
        self.input = input
        self.output = EditPersonalInfoViewModel.output(state: self.state)
        self.api = dependecies.api
        self.state.userDetail.accept(dependecies.userDetail)
        self.processInput()
    }

}

private extension EditPersonalInfoViewModel {

    func processInput() {
        self.input.saveTrigger
            .withLatestFrom(state.userDetail.asDriver()){($0, $1)}
            .drive {[state, complete, api, bag]  (save: SaveUserDetail, current: UserDetail) in
                state.isLoading.accept(true)
                if let hourlyCapacityText = save.hourlyCapacity {
                    api.update(userDetail: UserDetail(id: current.id, name: save.name, surname: save.surname, jobTitle: save.jobTitle, degree: save.degree, dateOfBirth: nil, hourlyCapacity: Int(hourlyCapacityText) ?? 0, phoneNumber: save.phoneNumber, contactEmail: save.contactEmail, workType: save.workType, hourRates: nil))
                        .subscribe { [complete, state] (userDetail) in
                            complete.accept(userDetail)
                            state.isLoading.accept(false)
                        } onError: { [state] (error) in
                            state.error.accept(error)
                            state.isLoading.accept(false)
                        }.disposed(by: bag)
                }

            }.disposed(by: bag)
    }

    static func output(state: State) -> EditPersonalInfoViewPresentable.Output {
        return (
            name: state.userDetail.map{$0.name ?? ""}.asDriver(onErrorJustReturn: ""),
            surname: state.userDetail.map{$0.surname ?? ""}.asDriver(onErrorJustReturn: ""),
            jobTitle: state.userDetail.map{$0.jobTitle}.asDriver(onErrorJustReturn: nil),
            degree: state.userDetail.map{$0.degree ?? ""}.asDriver(onErrorJustReturn: ""),
            hourlyCapacity: state.userDetail.map{
                if let hourlyCapacity = $0.hourlyCapacity {
                    return String(describing: hourlyCapacity)
                }
                return ""
            }.asDriver(onErrorDriveWith: .empty()),
            phoneNumber: state.userDetail.map{$0.phoneNumber ?? ""}.asDriver(onErrorDriveWith: .empty()),
            contactEmail: state.userDetail.map{$0.contactEmail ?? ""}.asDriver(onErrorJustReturn: ""),
            workType: state.userDetail.map{$0.workType}.asDriver(onErrorJustReturn: nil),
            error: state.error.asDriver(onErrorDriveWith: .empty()),
            isLoading: state.isLoading.asDriver(onErrorJustReturn: false)
        )
    }
}

