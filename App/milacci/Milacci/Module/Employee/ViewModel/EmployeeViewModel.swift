//
//  EmployeeViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxDataSources

typealias EmployeeItemsSection = AnimatableSectionModel<String, EmployeeViewModel>

protocol EmployeeViewPresentable: IdentifiableType, Equatable {
    var firstName: String { get }
    var lastName: String { get }
    var employee: Employee { get }
}

struct EmployeeViewModel: EmployeeViewPresentable {
    static func == (lhs: EmployeeViewModel, rhs: EmployeeViewModel) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.employee.id == rhs.employee.id
    }

    var identity: Int {
        return employee.id
    }

    typealias Identity = Int

    var firstName: String
    var lastName: String
    var employee: Employee
}

extension EmployeeViewModel {

    init(withEmployee employee: Employee){
        self.employee = employee
        self.firstName = employee.name
        self.lastName = employee.surname
    }

}
