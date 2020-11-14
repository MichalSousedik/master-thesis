//
//  MyTeamViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 14/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import RxSwift

class MyTeamViewModel: UsersViewModel {

    override func load(page: Int, searchedText: String?) -> Observable<[Employee]> {
        return self.api.fetch(page: page, teamLeaderId: UserSettingsService.shared.userId, searchedText: searchedText)
            .asObservable()
    }

}
