
//  MilacciUITests.swift
//  MilacciUITests
//
//  Created by Michal Sousedik on 17/12/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import XCTest
@testable import Milacci


class UserWorkflowUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGoogleSignIn() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["-mockUser"]
        app.launch()
        
        if app.tabBars["Řádek panelů"].buttons["Profil"].exists {
            app.tabBars["Řádek panelů"].buttons["Profil"].tap()
            app.navigationBars["Milacci.UserProfileView"].buttons["esc"].tap()
        }
        
        
        app/*@START_MENU_TOKEN@*/.buttons["GIDSignInButton"]/*[[".buttons[\"Sign in\"]",".buttons[\"GIDSignInButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        addUIInterruptionMonitor(withDescription: "") { (alert) -> Bool in
                        
                          let button = alert.buttons["Continue"]
                        
                          if button.exists {
                              button.tap()
                              return true
                          }
                        
                          return false
                      }
        app.tap()
        app.activate()
        sleep(5)
        
        if app.webViews.webViews.webViews.links["Test User test.user@ack.ee"].staticTexts["test.user@ack.ee"].exists {
            app.webViews.webViews.webViews.links["Test User test.user@ack.ee"].staticTexts["test.user@ack.ee"].tap()
        } else {
            app/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.staticTexts["Použít jiný účet"]/*[[".otherElements[\"BrowserView?WebViewProcessID=4853\"].webViews.webViews.webViews",".otherElements[\"Přihlášení – účty Google\"]",".links.matching(identifier: \"Použít jiný účet\").staticTexts[\"Použít jiný účet\"]",".staticTexts[\"Použít jiný účet\"]",".webViews.webViews.webViews"],[[[-1,4,1],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
            app.webViews.webViews.webViews.textFields["E-mail nebo telefon"].tap()
            
            
            if app/*@START_MENU_TOKEN@*/.buttons["Keyboard"]/*[[".otherElements[\"SFAutoFillInputView\"].buttons[\"Keyboard\"]",".buttons[\"Keyboard\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists {
                app/*@START_MENU_TOKEN@*/.buttons["Keyboard"]/*[[".otherElements[\"SFAutoFillInputView\"].buttons[\"Keyboard\"]",".buttons[\"Keyboard\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            }
            
            app.keys["t"].tap()
            app.keys["e"].tap()
            app.keys["s"].tap()
            app.keys["t"].tap()
            app.keys["."].tap()
            app.keys["u"].tap()
            app.keys["s"].tap()
            app.keys["e"].tap()
            app.keys["r"].tap()
            app.keys["@"].tap()
            app.keys["a"].tap()
            app.keys["c"].tap()
            app.keys["k"].tap()
            app.keys["."].tap()
            app.keys["e"].tap()
            app.keys["e"].tap()
            app.toolbars.matching(identifier: "Toolbar").buttons["Done"].tap()
            app/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.buttons["Další"]/*[[".otherElements[\"BrowserView?WebViewProcessID=5882\"].webViews.webViews.webViews",".otherElements[\"Přihlášení – účty Google\"].buttons[\"Další\"]",".buttons[\"Další\"]",".webViews.webViews.webViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
            
            
            app/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.secureTextFields["Zadejte heslo"]/*[[".otherElements[\"BrowserView?WebViewProcessID=5967\"].webViews.webViews.webViews",".otherElements[\"Přihlášení – účty Google\"].secureTextFields[\"Zadejte heslo\"]",".secureTextFields[\"Zadejte heslo\"]",".webViews.webViews.webViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
            if app/*@START_MENU_TOKEN@*/.buttons["Keyboard"]/*[[".otherElements[\"SFAutoFillInputView\"].buttons[\"Keyboard\"]",".buttons[\"Keyboard\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists {
                app/*@START_MENU_TOKEN@*/.buttons["Keyboard"]/*[[".otherElements[\"SFAutoFillInputView\"].buttons[\"Keyboard\"]",".buttons[\"Keyboard\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            }
            
            app.keys["m"].tap()
            app.keys["i"].tap()
            app.keys["l"].tap()
            app.keys["a"].tap()
            app.keys["c"].tap()
            app.keys["c"].tap()
            app.keys["i"].tap()
            app.keys["t"].tap()
            app.keys["e"].tap()
            app.keys["s"].tap()
            app.keys["t"].tap()
            
            app.toolbars.matching(identifier: "Toolbar").buttons["Done"].tap()
            app/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.buttons["Další"]/*[[".otherElements[\"BrowserView?WebViewProcessID=5882\"].webViews.webViews.webViews",".otherElements[\"Přihlášení – účty Google\"].buttons[\"Další\"]",".buttons[\"Další\"]",".webViews.webViews.webViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        }
        
        if !app.tabBars["Řádek panelů"].buttons["Profil"].exists {
            sleep(5)
        }

        app.tabBars["Řádek panelů"].buttons["Profil"].tap()
        
        app.navigationBars["Milacci.UserProfileView"].buttons["esc"].tap()
        
    }
    
    func testMyInvoice() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-withoutGoogleSignIn", "-mockUser"]
        app.launch()

        
        let tablesQuery = app.tables
        if tablesQuery.cells.containing(.staticText, identifier:"Prosinec 2019").children(matching: .other).element(boundBy: 1).exists {
            XCTFail("Prosinec 2019 is visible")
        }
        tablesQuery.cells.containing(.staticText, identifier:"Červen 2020").children(matching: .other).element(boundBy: 1).press(forDuration: 1, thenDragTo: XCUIApplication().staticTexts["Faktury"])
        
        if !tablesQuery.cells.containing(.staticText, identifier:"Prosinec 2019").children(matching: .other).element(boundBy: 1).exists {
            XCTFail("Prosinec 2019 is not visible")
        }
        
        tablesQuery.cells.containing(.staticText, identifier:"Únor 2020").children(matching: .other).element(boundBy: 1).press(forDuration: 1, thenDragTo: tablesQuery.cells.containing(.staticText, identifier:"Listopad 2019").children(matching: .other).element(boundBy: 1))
        tablesQuery.cells.containing(.staticText, identifier:"Srpen 2020").children(matching: .other).element(boundBy: 1).press(forDuration: 1, thenDragTo: tablesQuery.cells.containing(.staticText, identifier:"Duben 2020").children(matching: .other).element(boundBy: 1))
        tablesQuery.cells.containing(.staticText, identifier:"Říjen 2020").children(matching: .other).element(boundBy: 1).press(forDuration: 1, thenDragTo: tablesQuery.cells.containing(.staticText, identifier:"Srpen 2020").children(matching: .other).element(boundBy: 1))
        
        
        if tablesQuery.cells.containing(.staticText, identifier:"Prosinec 2019").children(matching: .other).element(boundBy: 1).exists {
            XCTFail("Prosinec 2019 is visible")
        }
        
    }
    
    func testWage() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["-withoutGoogleSignIn", "-mockUser"]
        app.launch()

        app.tabBars["Řádek panelů"].buttons["Mzda"].tap()
        if !app.staticTexts["300 Kč"].exists {
            XCTFail("Current Hour Rate is not 300 Kč")
        }
        sleep(5)
        app.otherElements[" 09-2020: 10000"].swipeLeft()
        if !app.otherElements[" 05-2020: 15000"].exists {
            XCTFail("Column for wage does not exist")
        }
        app.otherElements[" 05-2020: 15000"].tap()
        if !app.staticTexts["15 000 Kč"].exists {
            XCTFail("Value is not presented, even after column tap")
            
        }
        
    }
    
    func testsProfile() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["-withoutGoogleSignIn", "-mockUser"]
        app.launch()
        
        app.tabBars["Řádek panelů"].buttons["Profil"].tap()
        
        if !app.staticTexts["733 000 121"].exists {
            XCTFail("Phonenumber is not presented")
            
        }
        
    }
}
