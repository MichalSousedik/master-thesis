//
//  Date+LocalFormat.swift
//  Milacci
//
//  Created by Michal Sousedik on 19/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

extension Date {

    var localFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd. MM. yyyy"
        return formatter.string(from: self)
    }

    var monthYearFormat: String {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        return "\(monthFormatter.string(from: self).month) \(yearFormatter.string(from: self))"
    }

    var periodFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: self)
    }

}
