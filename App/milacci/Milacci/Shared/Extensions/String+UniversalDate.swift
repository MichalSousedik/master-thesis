//
//  String+UniversalDate.swift
//  Milacci
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

extension String {
    var universalDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
}
