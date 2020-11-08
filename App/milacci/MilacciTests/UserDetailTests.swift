//
//  UserDetailTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import XCTest
@testable import Milacci

class UserDetailTests: XCTestCase {

    func testCurrentHourRate_emptyHourRates() {
        let userDetail = UserDetail(name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [])
        XCTAssertNil(try userDetail.currentHourRate())
    }
    
    func testCurrentHourRate_oneHourRate() {
        let hourRate =
            HourRate(id: 1, since: "2020-02-24T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        let userDetail = UserDetail(name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [hourRate])
        XCTAssertEqual(try userDetail.currentHourRate(), hourRate)
    }
    
    func testCurrentHourRate_fourHourRates() {
        let hourRate =
            HourRate(id: 1, since: "2020-02-24T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        let userDetail = UserDetail(name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [
            hourRate,
            HourRate(id: 2, since: "2020-02-05T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0),
            HourRate(id: 3, since: "2020-01-02T23:59:59.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0),
            HourRate(id: 4, since: "2020-01-01T23:59:59.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        ])
        XCTAssertEqual(try userDetail.currentHourRate(), hourRate)
    }
    
    func testCurrentHourRate_wrongSinceFormat() {
        let hourRate =
            HourRate(id: 1, since: "2020-02-24T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        let userDetail = UserDetail(name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [
            hourRate,
            HourRate(id: 2, since: "2020-02-05T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0),
            HourRate(id: 3, since: "2020-01-02T23:59:59.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0),
            HourRate(id: 4, since: "01.01.2020T23:59:59.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        ])
        XCTAssertThrowsError(try userDetail.currentHourRate())
    }
    
    
}
