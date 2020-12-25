//
//  FirstLetterGroupTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 03/12/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import XCTest
@testable import Milacci

class FirstLetterGroupTests: XCTestCase {

    func testEquality_ab_false() {
        let a = FirstLetterGroup(firstLetter: "a", models: [])
        let b = FirstLetterGroup(firstLetter: "b", models: [])
        
        let result = a == b
        
        XCTAssertFalse(result)
    }
    
    func testEquality_bb_true() {
        let a = FirstLetterGroup(firstLetter: "b", models: [])
        let b = FirstLetterGroup(firstLetter: "b", models: [])
        
        let result = a == b
        
        XCTAssertTrue(result)
    }
    
    func testCompare_aleb_true() {
        let a = FirstLetterGroup(firstLetter: "a", models: [])
        let b = FirstLetterGroup(firstLetter: "b", models: [])
        
        let result = a < b
        
        XCTAssertTrue(result)
    }
    
    func testCompare_blea_false() {
        let a = FirstLetterGroup(firstLetter: "a", models: [])
        let b = FirstLetterGroup(firstLetter: "b", models: [])
        
        let result = b < a
        
        XCTAssertFalse(result)
    }
    
}
