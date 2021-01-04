//
//  TeamLeaderWorkflowUITest.swift
//  MilacciUITests
//
//  Created by Michal Sousedik on 03/01/2021.
//  Copyright © 2021 Michal Sousedik. All rights reserved.
//

import XCTest

class TeamLeaderWorkflowUITest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func testMyTeam() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-withoutGoogleSignIn", "-mockTeamLeader"]
        app.launch()

        app.tabBars["Řádek panelů"].buttons["Můj tým"].tap()
        app.navigationBars["Můj tým"].searchFields["Vyhledat člena týmu"].tap()
        app.keys["U"].tap()
        app.keys["s"].tap()
        app.keys["e"].tap()
        app.keys["r"].tap()

        app.tables.cells.containing(.staticText, identifier:"User").element.tap()
        
        if !app.scrollViews.otherElements.staticTexts["01. 01. 2000"].exists {
            XCTFail("Date of Birth should be 01. 01. 2020")
        }
    }

}
