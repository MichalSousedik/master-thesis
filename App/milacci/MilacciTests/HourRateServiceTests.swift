//
//  HourRateServiceTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 02/01/2021.
//  Copyright © 2021 Michal Sousedik. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxBlocking
@testable import Milacci

class HourRateServiceTests: XCTestCase {
    
    func testCreate_success() throws {
        HourRateServiceMock.create(model: HourRate(id: 10, since: "", validTo: "", type: nil, value: 300.00, percentageIncrease: nil))
        XCTAssertEqual(try HourRateService.shared.create(value: 300.00, since: Date(), userId: 1).toBlocking().first()?.id, 10)
    }
    
    func testStats_success() throws {
        HourRateServiceMock.stats()
        XCTAssertEqual(try HourRateService.shared.stats(period: Date()).toBlocking().first()?.count, 1)
    }
    
}

