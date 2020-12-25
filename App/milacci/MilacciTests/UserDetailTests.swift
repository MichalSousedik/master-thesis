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
    
    func testCurrentHourRate_emptyHourRates_nil() {
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [])
        XCTAssertNil(try userDetail.currentHourRate())
    }
    
    func testCurrentHourRate_nilHourRates_nil() {
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: nil)
        XCTAssertNil(try userDetail.currentHourRate())
    }
    
    func testCurrentHourRate_oneHourRate_oneHourRate() {
        let hourRate =
            HourRate(id: 1, since: "2020-02-24T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [hourRate])
        XCTAssertEqual(try userDetail.currentHourRate(), hourRate)
    }
    
    func testCurrentHourRate_fourHourRates_maxHourRateWithValidSinceLessThanToday() {
        let hourRate =
            HourRate(id: 1, since: "2020-02-24T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [
            hourRate,
            HourRate(id: 2, since: "2020-02-05T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0),
            HourRate(id: 3, since: "2020-01-02T23:59:59.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0),
            HourRate(id: 4, since: "2020-01-01T23:59:59.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        ])
        XCTAssertEqual(try userDetail.currentHourRate(), hourRate)
    }
    
    func testCurrentHourRate_threeHourRatesAndOneIsUpcomming_maxHourRateWithValidSinceLessThanToday() {
        let hourRate =
            HourRate(id: 1, since: "2020-12-01T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [
            hourRate,
            HourRate(id: 2, since: "2999-02-05T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0),
            HourRate(id: 3, since: "2020-01-02T23:59:59.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        ])
        XCTAssertEqual(try userDetail.currentHourRate(), hourRate)
    }
    
    func testCurrentHourRate_wrongSinceFormat() {
        let hourRate =
            HourRate(id: 1, since: "2020-02-24T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [
            hourRate,
            HourRate(id: 2, since: "2020-02-05T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0),
            HourRate(id: 3, since: "2020-01-02T23:59:59.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0),
            HourRate(id: 4, since: "01.01.2020T23:59:59.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        ])
        XCTAssertThrowsError(try userDetail.currentHourRate())
    }
    
    func testUpcommingHourRate_emptyHourRates_nil() {
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [])
        XCTAssertNil(try userDetail.upcommingHourRate())
    }
    
    func testUpcommingHourRate_nilHourRates_nil() {
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: nil)
        XCTAssertNil(try userDetail.upcommingHourRate())
    }
    
    func testUpcommingHourRate_oneCurrentHourRate_nil() {
        let hourRate =
            HourRate(id: 1, since: "2020-02-24T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [hourRate])
                
        XCTAssertNil(try userDetail.upcommingHourRate())
    }
    
    func testUpcommingHourRate_oneUpcommingHourRateOneCurrent_upcommingHourRate() {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        let hourRate =
            HourRate(id: 1, since: futureDate?.iso8601withFractionalSeconds ?? "", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        let userDetail = UserDetail(id: 1, name: nil, surname: nil, jobTitle: nil, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: [
            hourRate,
            HourRate(id: 2, since: "2020-02-05T23:00:00.000Z", validTo: "2020-12-05T23:00:00.000Z", type: .original, value: 1.0, percentageIncrease: 1.0)
        ])
        
        XCTAssertEqual(try userDetail.upcommingHourRate(), hourRate)
    }
    
    func testFormattedDateOfBirth_doesNoExist_nil() {
        let userDetail = UserDetail(id: 1, name: "", surname: "", jobTitle: nil, degree: "", dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: nil)
        let result = userDetail.formattedDateOfBirth
        XCTAssertNil(result)
    }
    func testFormattedDateOfBirth_validDate_dateOfBirth() {
        let userDetail = UserDetail(id: 1, name: "", surname: "", jobTitle: nil, degree: "", dateOfBirth: "2020-02-03", hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: nil)
        let result = userDetail.formattedDateOfBirth
        XCTAssertEqual(result, "03. 02. 2020")
    }
    
    
}
