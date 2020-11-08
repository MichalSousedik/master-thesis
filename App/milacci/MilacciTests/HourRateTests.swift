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
        
        XCTAssertEqual(hourRate.sinceDate?.timeIntervalSince1970, 1582585200, "Since Date is not calculated properly")
    }
    
    func testSinceDate_incorrectFormat() {
        let hourRate = HourRate(id: 1, since: "24.02.2020T23:00:00.000Z", validTo: nil, type: .original, value: 1.0, percentageIncrease: 1.0)
        XCTAssertNil(hourRate.sinceDate)
    }
    
}
