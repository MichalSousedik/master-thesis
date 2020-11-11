//
//  FirstLetterGroup.swift
//  Milacci
//
//  Created by Michal Sousedik on 11/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

struct FirstLetterGroup: Comparable {
    static func < (lhs: FirstLetterGroup, rhs: FirstLetterGroup) -> Bool {
        return lhs.firstLetter < rhs.firstLetter
    }

    static func == (lhs: FirstLetterGroup, rhs: FirstLetterGroup) -> Bool {
        return lhs.firstLetter == rhs.firstLetter
    }

    var firstLetter: String
    var employees: [EmployeeViewModel]
}
