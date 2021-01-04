//
//  MilacciTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import XCTest
@testable import Milacci

class HourRateTests: XCTestCase {

    func testSinceDate_correctFormat() {
        let hourRate = HourRate(id: 1, since: "2020-02-24T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        
        XCTAssertEqual(hourRate.since.universalDate?.timeIntervalSince1970, 1582585200, "Since Date is not calculated properly")
    }
    
    func testSinceDate_incorrectFormat() {
        let hourRate = HourRate(id: 1, since: "24.02.2020T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        XCTAssertNil(hourRate.since.universalDate)
    }
    
    func testDayFormat_zeroDays_days() {
        let result = HourRate.dayFormat(numberOfDays: 0)
        XCTAssertEqual(result, "dní")
    }
    
    func testDayFormat_oneDay_day() {
        let result = HourRate.dayFormat(numberOfDays: 1)
        XCTAssertEqual(result, "den")
    }
    
    func testDayFormat_twoDays_days() {
        let result = HourRate.dayFormat(numberOfDays: 2)
        XCTAssertEqual(result, "dny")
    }
    
}
