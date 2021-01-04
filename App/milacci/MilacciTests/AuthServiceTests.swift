//
//  AuthServiceTests.swift
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

class AuthServiceTests: XCTestCase {
    
    func testSignIn_success() {
        AuthServiceMock.signIn(role: "user")
        XCTAssertEqual(try AuthService.shared.signIn(accessToken: "Google Access Token").toBlocking().first()?.credentials.accessToken, "Ackee Access Token")
    }
    
    func testRefresh_success() {
        AuthServiceMock.refresh()
        XCTAssertEqual(try AuthService.shared.refresh(refreshToken: "Refresh token").toBlocking().first()?.credentials.accessToken, "New Ackee Access Token")
    }
    
}
