//
//  UserDetail.swift
//  Milacci
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

typealias EmployeesResponse = [UserDetail]
typealias Employee = UserDetail

struct UserDetail: Codable {
    let id: Int
    let name: String?
    let surname: String?
    let jobTitle: JobTitle?
    let degree: String?
    let dateOfBirth: String?
    let hourlyCapacity: Int?
    let phoneNumber: String?
    let contactEmail: String?
    let workType: WorkType?
    let hourRates: [HourRate]?
}

extension UserDetail {

    var formattedDateOfBirth: String? {
        guard let dateOfBirth = dateOfBirth else {return nil}
        let parts = dateOfBirth.components(separatedBy: "-")
        let year = parts[0]
        let month = parts[1]
        let day = parts[2]
        return "\(day). \(month). \(year)"
    }

    func upcommingHourRate(today: Date = Date()) throws -> HourRate? {
        return try findUpcommingHourRate(hourRates: hourRates, today: today)
    }

    private func findUpcommingHourRate(hourRates: [HourRate]?, today: Date) throws ->  HourRate? {
        guard let hourRates = hourRates else {return nil}
        let hourRate = try hourRates.max { (a, b) -> Bool in
            let aSinceDate = try findSinceUniversalDate(hourRate: a)
            let bSinceDate = try findSinceUniversalDate(hourRate: b)
            return aSinceDate < bSinceDate
        }

        guard let unwrappedHourRate = hourRate else {return nil}
        if let sinceDate = unwrappedHourRate.since.universalDate,
           sinceDate > Date(),
           unwrappedHourRate.validTo == nil {
            return hourRate
        } else {
            return try findUpcommingHourRate(hourRates: hourRates.filter({[unwrappedHourRate] (hRate) -> Bool in
                hRate.id != unwrappedHourRate.id
            }), today: today)
        }
    }

    func currentHourRate() throws -> HourRate? {
        return try findCurrentHourRate(hourRates: hourRates)
    }

    private func findCurrentHourRate(hourRates: [HourRate]?) throws ->  HourRate? {
        guard let hourRates = hourRates else {return nil}
        let hourRate = try hourRates.max { (a, b) -> Bool in
            let aSinceDate = try findSinceUniversalDate(hourRate: a)
            let bSinceDate = try findSinceUniversalDate(hourRate: b)
            return aSinceDate < bSinceDate
        }

        guard let unwrappedHourRate = hourRate else {return nil}
        if let sinceDate = unwrappedHourRate.since.universalDate,
           sinceDate < Date() {
            return hourRate
        } else {
            return try findCurrentHourRate(hourRates: hourRates.filter({[unwrappedHourRate] (hRate) -> Bool in
                hRate.id != unwrappedHourRate.id
            }))
        }
    }

    private func findSinceUniversalDate(hourRate: HourRate) throws -> Date {
        guard let sinceDate = hourRate.since.universalDate else {
            throw HourRateError.sinceInWrongFormat(id: hourRate.id)
        }
        return sinceDate
    }

}
