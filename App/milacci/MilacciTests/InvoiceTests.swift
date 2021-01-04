//
//  InvoiceTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 03/12/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import XCTest
@testable import Milacci

class InvoiceTests: XCTestCase {
    
    func testOverviewPeriodOfIssue_emptyPeriodOfIssue_empty() {
        let invoice = Invoice(id: 1, periodOfIssue: "", state: InvoiceState.notIssued, value: nil, filename: nil, userWorkType: nil, user: nil)
        let result = invoice.overviewPeriodOfIssue
        XCTAssertEqual(result, "")
    }
    
    func testOverviewPeriodOfIssue_valid_correctFormat() {
        for month in 1...12 {
            let periodOfIssue = "2020-\(String(format: "%02d", month))"
            let invoice = Invoice(id: 1, periodOfIssue: periodOfIssue, state: InvoiceState.notIssued, value: nil, filename: nil, userWorkType: nil, user: nil)
            let result = invoice.overviewPeriodOfIssue
            XCTAssertEqual(result, "\(String(format: "%02d", month).month) 2020")
        }
    }
    
    func testChartPeriodOfIssue_emptyPeriodOfIssue_empty() {
        let invoice = Invoice(id: 1, periodOfIssue: "", state: InvoiceState.notIssued, value: nil, filename: nil, userWorkType: nil, user: nil)
        let result = invoice.chartPeriodOfIssue
        XCTAssertEqual(result, "")
    }
    
    func testChartPeriodOfIssue_valid_correctFormat() {
        let invoice = Invoice(id: 1, periodOfIssue: "2020-01", state: InvoiceState.notIssued, value: nil, filename: nil, userWorkType: nil, user: nil)
        let result = invoice.chartPeriodOfIssue
        XCTAssertEqual(result, "01-2020")
    }
    
    func testInit_spreadOperator_state() {
        let expected = Invoice(id: 1, periodOfIssue: "2020-01", state: InvoiceState.notIssued, value: "100", filename: nil, userWorkType: nil, user: nil)
        let invoice = Invoice(id: 1, periodOfIssue: "2020-01", state: InvoiceState.approved, value: "100", filename: nil, userWorkType: nil, user: nil)
        let invoiceSpread = Invoice(invoice, state: InvoiceState.notIssued)
        
        XCTAssertEqual(invoiceSpread, expected)
    }
    
    func testInit_spreadOperator_equalObject() {
        let invoice = Invoice(id: 1, periodOfIssue: "2020-01", state: InvoiceState.approved, value: "100", filename: nil, userWorkType: nil, user: nil)
        let invoiceSpread = Invoice(invoice)
        
        XCTAssertEqual(invoiceSpread, invoice)
    }
    
    func testAllowedTransition_notIssued_empty() {
        let invoiceState = InvoiceState.notIssued
        let result = invoiceState.allowedTransitions
        XCTAssertEqual(result, [])
    }
    
    func testAllowedTransition_paid_approvedAndNotIssued() {
        let invoiceState = InvoiceState.paid
        let result = invoiceState.allowedTransitions
        XCTAssertEqual(result, [InvoiceState.approved, InvoiceState.notIssued])
    }
    
    func testAllowedTransition_approved_paidAndNotIssued() {
        let invoiceState = InvoiceState.approved
        let result = invoiceState.allowedTransitions
        XCTAssertEqual(result, [InvoiceState.paid, InvoiceState.notIssued])
    }
    
    func testAllowedTransition_waiting_approvedAndPaidAndNotIssued() {
        let invoiceState = InvoiceState.waiting
        let result = invoiceState.allowedTransitions
        XCTAssertEqual(result, [InvoiceState.approved, InvoiceState.paid, InvoiceState.notIssued])
    }
    
    func testBackgroundColor_notIssued_gray() {
        let invoiceState = InvoiceState.notIssued
        let result = invoiceState.backgroundColor
        XCTAssertEqual(result, UIColor.gray)
    }
    
    func testBackgroundColor_paid_secondary() {
        let invoiceState = InvoiceState.paid
        let result = invoiceState.backgroundColor
        XCTAssertEqual(result, Asset.Colors.chartBarDefault.color)
    }
    
    func testBackgroundColor_approved_primary() {
        let invoiceState = InvoiceState.approved
        let result = invoiceState.backgroundColor
        XCTAssertEqual(result, Asset.Colors.primary1.color)
    }
    
    func testBackgroundColor_waiting_white() {
        let invoiceState = InvoiceState.waiting
        let result = invoiceState.backgroundColor
        XCTAssertEqual(result, UIColor.white)
    }
    
    func testDescription_notIssued_new() {
        let invoiceState = InvoiceState.notIssued
        let result = invoiceState.description
        XCTAssertEqual(result, "Nová")
    }
    
    func testDescription_paid_paid() {
        let invoiceState = InvoiceState.paid
        let result = invoiceState.description
        XCTAssertEqual(result, "Zaplacená")
    }
    
    func testDescription_approved_approved() {
        let invoiceState = InvoiceState.approved
        let result = invoiceState.description
        XCTAssertEqual(result, "Schválená")
    }
    
    func testDescription_waiting_waiting() {
        let invoiceState = InvoiceState.waiting
        let result = invoiceState.description
        XCTAssertEqual(result, "Čekajicí")
    }
    
    func testIcon_notIssued_return() {
        let invoiceState = InvoiceState.notIssued
        let result = invoiceState.icon
        XCTAssertEqual(result, "⏎")
    }
    
    func testIcon_paid_dollar() {
        let invoiceState = InvoiceState.paid
        let result = invoiceState.icon
        XCTAssertEqual(result, "$")
    }
    
    func testIcon_approved_tick() {
        let invoiceState = InvoiceState.approved
        let result = invoiceState.icon
        XCTAssertEqual(result, "✓")
    }
    
    func testIcon_waiting_timer() {
        let invoiceState = InvoiceState.waiting
        let result = invoiceState.icon
        XCTAssertEqual(result, "⏳")
    }
    
    func testImage_notIssued_return() {
        let invoiceState = InvoiceState.notIssued
        let result = invoiceState.image
        XCTAssertEqual(result, UIImage(systemSymbol: .return))
    }
    
    func testImage_paid_dollar() {
        let invoiceState = InvoiceState.paid
        let result = invoiceState.image
        XCTAssertEqual(result, UIImage(systemSymbol: .dollarsignCircle))
    }
    
    func testImage_approved_checkmark() {
        let invoiceState = InvoiceState.approved
        let result = invoiceState.image
        XCTAssertEqual(result, UIImage(systemSymbol: .checkmark))
    }
    
    func testImage_waiting_timer() {
        let invoiceState = InvoiceState.waiting
        let result = invoiceState.image
        XCTAssertEqual(result, UIImage(systemSymbol: .timer))
    }
    
    func testSegmentedControlOrder_notIssued_two() {
        let invoiceState = InvoiceState.notIssued
        let result = invoiceState.segmentedControlOrder
        XCTAssertEqual(result, 2)
    }
    
    func testSegmentedControlOrder_paid_three() {
        let invoiceState = InvoiceState.paid
        let result = invoiceState.segmentedControlOrder
        XCTAssertEqual(result, 3)
    }
    
    func testSegmentedControlOrder_approved_one() {
        let invoiceState = InvoiceState.approved
        let result = invoiceState.segmentedControlOrder
        XCTAssertEqual(result, 1)
    }
    
    func testSegmentedControlOrder_waiting_zero() {
        let invoiceState = InvoiceState.waiting
        let result = invoiceState.segmentedControlOrder
        XCTAssertEqual(result, 0)
    }
}
