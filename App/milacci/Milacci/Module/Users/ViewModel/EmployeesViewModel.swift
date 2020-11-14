//
//  AdminEmployeesViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 13/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import RxSwift

class EmployeesViewModel: UsersViewModel {

    override func load(page: Int, searchedText: String?) -> Observable<[Employee]> {
        return self.api.fetch(page: page, teamLeaderId: nil, searchedText: searchedText)
            .asObservable()
    }

}
