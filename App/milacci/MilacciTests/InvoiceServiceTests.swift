//
//  InvoiceServiceTests.swift
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

class InvoiceServiceTests: XCTestCase {
    
    func testFetch_success() throws {
        InvoiceServiceMock.employeesInvoices()
        XCTAssertEqual(try InvoiceService.shared.fetch(page: 1, userId: 1, periodOfIssue: Date(), state: .waiting).toBlocking().first()?.count, 10)
    }
    
    func testDetail_success() throws {
        InvoiceServiceMock.detail()
        XCTAssertEqual(try InvoiceService.shared.detail(id: 989).toBlocking().first()?.id, 989)
    }
    
    func testUpdate_success() throws {
        let invoice = Invoice(id: 989, periodOfIssue: "2020-03", state: .approved, value: "4000", filename: "", userWorkType: .agreement, user: nil)
        InvoiceServiceMock.update(model: invoice)
        XCTAssertEqual(try InvoiceService.shared.update(invoice: invoice, url: nil).toBlocking().first()?.id, 989)
    }
    
}
