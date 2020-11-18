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

    func upcommingHourRate() throws -> HourRate? {
        return try findUpcommingHourRate(hourRates: hourRates)
    }

    private func findUpcommingHourRate(hourRates: [HourRate]?) throws ->  HourRate? {
        guard let hourRates = hourRates else {return nil}
        if hourRates.count == 0 {
            return nil
        }
        let hourRate = try hourRates.max { (a, b) -> Bool in
            guard let aSinceDate = a.since.universalDate else {
                throw HourRateError.sinceInWrongFormat(id: a.id)
            }
            guard let bSinceDate = b.since.universalDate else {
                throw HourRateError.sinceInWrongFormat(id: b.id)
            }
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
            }))
        }
    }

    func currentHourRate() throws -> HourRate? {
        return try findCurrentHourRate(hourRates: hourRates)
    }

    private func findCurrentHourRate(hourRates: [HourRate]?) throws ->  HourRate? {
        guard let hourRates = hourRates else {return nil}
        if hourRates.count == 0 {
            return nil
        }
        let hourRate = try hourRates.max { (a, b) -> Bool in
            guard let aSinceDate = a.since.universalDate else {
                throw HourRateError.sinceInWrongFormat(id: a.id)
            }
            guard let bSinceDate = b.since.universalDate else {
                throw HourRateError.sinceInWrongFormat(id: b.id)
            }
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

}
