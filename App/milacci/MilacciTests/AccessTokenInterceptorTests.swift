//
//  AccessTokenInterceptorTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 02/01/2021.
//  Copyright © 2021 Michal Sousedik. All rights reserved.
//

import XCTest
import Alamofire
import RxCocoa
import RxSwift
import RxTest
@testable import Milacci

class AccessTokenInterceptorTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
   
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func testRetry_noSuccessAfterThreeTries_error() {
        AuthServiceMock.refresh()
        InvoiceServiceMock.unauthorizedAfterThreeRetries()
        
        
        XCTAssertThrowsError(try InvoiceService.shared.fetch(page: 1, userId: 1, periodOfIssue: Date(), state: .approved).toBlocking().toArray())
    }
    
    func testRetry_successAfterThreeTries_invoices() {
        AuthServiceMock.refresh()
        InvoiceServiceMock.authorizedAfterTwoRetries()
            
            
        XCTAssertEqual(try InvoiceService.shared.fetch(page: 1, userId: 1, periodOfIssue: Date(), state: .approved).toBlocking().first(), [])
    }
}
