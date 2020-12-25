//
//  UserSettingsServiceTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 03/12/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import XCTest
@testable import Milacci

class UserSettingsServiceTests: XCTestCase {
    
    var api: UserSettingsAPI!
    
    override func setUp() {
        super.setUp()
        api = UserSettingsService.shared
    }
    
    override func tearDown() {
        api.clearAll()
        super.tearDown()
    }
    
    func testSaveCredentials(){
        let accessToken = "accessToken"
        let refreshToken = "refreshToken"
        api.saveCredentials(credentials: Credentials(accessToken: accessToken, refreshToken: refreshToken, expiresIn: 3600))
        XCTAssertEqual(api.accessToken!, accessToken)
        XCTAssertEqual(api.refreshToken!, refreshToken)
    }
    
    func testSaveUser_userWithRole_idWithRole(){
        api.saveUser(user: User(id: 1, roles: [Role.admin]))
        XCTAssertEqual(api.userId, 1)
    }
    
    func testSaveUser_userWithoutRole_emptyArray(){
        api.saveUser(user: User(id: 1, roles: nil))
        XCTAssertNil(api.getSignInModel()?.user.roles)
    }
    
    func testSaveCredentialsAndUser_singInModel(){
        let accessToken = "accessToken"
        let refreshToken = "refreshToken"
        let id = 1
        let roles = [Role.admin]
        
        api.saveCredentials(credentials: Credentials(accessToken: accessToken, refreshToken: refreshToken, expiresIn: 3600))
        api.saveUser(user: User(id: id, roles: roles))
        
        let signInModel = api.getSignInModel()
        
        XCTAssertEqual(signInModel?.user.id, id)
        XCTAssertEqual(signInModel?.user.roles, roles)
        XCTAssertEqual(signInModel?.credentials.accessToken, accessToken)
        XCTAssertEqual(signInModel?.credentials.refreshToken, refreshToken)
        
    }
    
    func testClearAccessToken(){
        let accessToken = "accessToken"
        api.saveCredentials(credentials: Credentials(accessToken: accessToken, refreshToken: "", expiresIn: 3600))
        api.clearAccessToken()
        XCTAssertEqual(api.accessToken, nil)
    }
}
