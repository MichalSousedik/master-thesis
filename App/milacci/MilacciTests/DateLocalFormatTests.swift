//
//  DateLocalFormatTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 03/12/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import XCTest
@testable import Milacci

class DateLocalFormatTests: XCTestCase {
    
    func testLocalFormat(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let result = formatter.date(from: "2016/10/08 22:31")?.localFormat
        XCTAssertEqual(result ?? "", "08. 10. 2016")
    }
    
    func testMonthYearFormat(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let result = formatter.date(from: "2016/10/08 22:31")?.monthYearFormat
        XCTAssertEqual(result ?? "", "\(L10n.october) 2016")
    }
    
    func testPeriodFormat(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let result = formatter.date(from: "2016/10/08 22:31")?.periodFormat
        XCTAssertEqual(result ?? "", "2016-10")
    }
    
}
