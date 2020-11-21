//
//  EmployeeViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxDataSources

typealias UserItemsSection = AnimatableSectionModel<String, UserViewModel>

protocol UserViewPresentable: IdentifiableType, Equatable {
    var firstName: String { get }
    var lastName: String { get }
    var employee: Employee { get }
}

struct UserViewModel: UserViewPresentable {
    static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.employee.id == rhs.employee.id
    }

    typealias Identity = Int

    var firstName: String
    var lastName: String
    var employee: Employee

    var identity: Int {
        return employee.id
    }

}

extension UserViewModel {

    init(withEmployee employee: Employee){
        self.employee = employee
        self.firstName = employee.name ?? "-"
        self.lastName = employee.surname ?? "-"
    }

}
