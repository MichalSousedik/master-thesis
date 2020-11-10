//
//  EmployeeViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxDataSources

typealias EmployeeItemsSection = SectionModel<Int, EmployeeViewPresentable>

protocol EmployeeViewPresentable {
    var firstName: String { get }
    var lastName: String { get }
    var employee: Employee { get }
}

struct EmployeeViewModel: EmployeeViewPresentable {
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
