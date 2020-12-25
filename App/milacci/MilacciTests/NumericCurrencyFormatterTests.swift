//
//  NumericCurrencyFormatterTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 03/12/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import XCTest
@testable import Milacci

class NumericCurrencyFormatterTests: XCTestCase {
    
    func testToCzechCrowns_number_numberWithKc(){
        let value = 300
        let result = value.toCzechCrowns
        XCTAssertEqual(result, "300 Kč")
    }
    
}
