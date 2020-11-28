//
//  HourRate.swift
//  Milacci
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

struct HourRate: Codable {
    let id: Int
    let since: String
    let validTo: String?
    let type: HourRateType?
    let value: Double
    let percentageIncrease: Double?
}

enum HourRateType: String, Codable {
    case original = "original"
    case virtual = "virtual"
}

extension HourRate: Equatable {

    static func dayFormat(numberOfDays: Int) -> String {
        switch numberOfDays {
        case 1: return L10n.day
        case 2...4: return L10n.twoToFourDays
        default: return L10n.days
        }
    }

}

enum HourRateError: Error {
    case sinceInWrongFormat(id: Int)
}

extension HourRateError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .sinceInWrongFormat(let id):
            return "Hour rate with id \(id) contains 'since' date in a wrong format"
        }
    }
}
