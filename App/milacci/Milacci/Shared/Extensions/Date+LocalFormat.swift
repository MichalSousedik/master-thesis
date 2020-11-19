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

}
