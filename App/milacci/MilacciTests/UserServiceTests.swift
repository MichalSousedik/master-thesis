//
//  UserServiceTests.swift
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

class UserServiceTests: XCTestCase {

    func testDetail_success() throws {
        UserServiceMock.detail()
        XCTAssertEqual(try UserService.shared.detail(id: 1001).asObservable().toBlocking().first()?.id, 1001)
    }
    
    func testFetch_success() throws {
        UserServiceMock.fetch()
        XCTAssertEqual(try UserService.shared.fetch(page: 1, teamLeaderId: nil, searchedText: nil).asObservable().toBlocking().first()?.count, 3)
    }
    
    func testUpdate_success() throws {
        let userDetail = UserDetail(id: 1001, name: "Mate", surname: "Dragon", jobTitle: .accounts, degree: "Bc.", dateOfBirth: nil, hourlyCapacity: 160, phoneNumber: nil, contactEmail: nil, workType: .agreement, hourRates: [])
        UserServiceMock.update(model: userDetail)
        XCTAssertEqual(try UserService.shared.update(userDetail: userDetail).toBlocking().first()?.id, 1001)
    }
    
}
