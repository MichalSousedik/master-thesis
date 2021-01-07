//
//  AdminWorkflowUITest.swift
//  MilacciUITests
//
//  Created by Michal Sousedik on 03/01/2021.
//  Copyright © 2021 Michal Sousedik. All rights reserved.
//

import XCTest

class AdminWorkflowUITest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func testEmployeesInvoices() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-withoutGoogleSignIn", "-mockAdmin"]
        app.launch()

        let tablesQuery = app.tables
        let employeeinvoicetableviewcellCell = tablesQuery.children(matching: .cell).matching(identifier: "EmployeeInvoiceTableViewCell").element(boundBy: 0)
        let element = employeeinvoicetableviewcellCell.children(matching: .other).element(boundBy: 0)
        element.swipeLeft()
        tablesQuery.buttons["✓\nSchválit"].tap()
        app.buttons["Schválená"].tap()

        tablesQuery.cells["EmployeeInvoiceTableViewCell"].children(matching: .other).element(boundBy: 0).swipeLeft()
        tablesQuery.buttons["$\nZaplatit"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Zaplacená"]/*[[".segmentedControls.buttons[\"Zaplacená\"]",".buttons[\"Zaplacená\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element.swipeLeft()
        tablesQuery.buttons["⏎\nVrátit zpět"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Nová"]/*[[".segmentedControls.buttons[\"Nová\"]",".buttons[\"Nová\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        if !tablesQuery.cells["EmployeeInvoiceTableViewCell"].children(matching: .other).element(boundBy: 0).exists {
            XCTFail("New invoice does not exist")
        }
    }
    
    func testHourRateStats() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-withoutGoogleSignIn", "-mockAdmin"]
        app.launch()

        app.tabBars["Řádek panelů"].buttons["Nárůst platů"].tap()
        
        if !app.staticTexts["20.0 %"].exists {
           XCTFail("Incorrect average")
        }
        
        let tablesQuery = app.tables
        
        if !tablesQuery.cells.containing(.staticText, identifier:"Bro Pop").element.exists {
           XCTFail("Hour rate does not exist")
        }
    }
    
    func testEmployees() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-withoutGoogleSignIn", "-mockAdmin"]
        app.launch()

        app.tabBars["Řádek panelů"].buttons["Zaměstnanci"].tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Bro").element/*[[".cells.containing(.staticText, identifier:\"Pop\").element",".cells.containing(.staticText, identifier:\"Bro\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 0).buttons["upravit"].tap()
        app.textFields["0"].tap()
        
        app/*@START_MENU_TOKEN@*/.keys["6"]/*[[".keyboards.keys[\"6\"]",".keys[\"6\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.keys["0"].tap()
        app.keys["0"].tap()
        app.navigationBars["Nová hodinová sazba"].buttons["vybráno"].tap()
        sleep(3)
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 1).buttons["upravit"].tap()
        scrollViewsQuery.otherElements.textFields["Jméno"].tap()
        
        app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let toolbar = app/*@START_MENU_TOKEN@*/.toolbars["Toolbar"]/*[[".toolbars[\"Panel nástrojů\"]",".toolbars[\"Toolbar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let nextButton = toolbar.buttons["Next"]
        nextButton.tap()
        app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        nextButton.tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["Frontend Developer"].press(forDuration: 0.6);/*[[".pickers.pickerWheels[\"Frontend Developer\"]",".tap()",".press(forDuration: 0.6);",".pickerWheels[\"Frontend Developer\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        toolbar.buttons["Hotovo"].tap()
        
        let milacciEditpersonalinfoviewNavigationBar = app.navigationBars["Milacci.EditPersonalInfoView"]
        let vybrNoButton = milacciEditpersonalinfoviewNavigationBar.buttons["vybráno"]
        vybrNoButton.tap()
        
        
    }
}
