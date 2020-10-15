//
//  CurrencyFormatter.swift
//  Milacci
//
//  Created by Michal Sousedik on 26/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//
import Foundation

extension Formatter {
    static let toCzechCrowns: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.positiveSuffix = " Kč"
        return formatter
    }()
}

extension Numeric {
    var toCzechCrowns: String { Formatter.toCzechCrowns.string(for: self) ?? "" }
}
