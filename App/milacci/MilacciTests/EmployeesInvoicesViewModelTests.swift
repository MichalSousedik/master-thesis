//
//  EmployeesInvoicesViewModelTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 03/01/2021.
//  Copyright © 2021 Michal Sousedik. All rights reserved.
//


import XCTest
import Alamofire
import RxCocoa
import RxSwift
import RxTest
@testable import Milacci

class EmployeesInvoicesViewModelTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
   
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func testInitial_invoicesCount_one(){
        let invoicesCount = scheduler.createObserver(Int.self)
        let viewModel = EmployeesInvoicesViewModel(input: (periodOfIssueTrigger: .empty(), invoiceStateTrigger: .empty(), refreshTrigger: .empty(), loadNextPageTrigger: .empty(), loadingTrigger: .empty(), invoiceChanged: .empty()), api: EmployeesInvoicesServiceStub())
        viewModel.output.invoices
            .map({ (sections)  in
                sections.count
            })
            .drive(invoicesCount)
            .disposed(by: disposeBag)

        
        scheduler.start()
        
        
        XCTAssertEqual(invoicesCount.events, [
            .next(0, 1)
          ])
    }
    
    func testLoadNext_invoicesCount_five(){
        let loadNextPageTrigger =  PublishRelay<Void>()
        let invoicesCount = scheduler.createObserver(Int.self)
        let isLoadingMore = scheduler.createObserver(Bool.self)
        let viewModel = EmployeesInvoicesViewModel(input: (periodOfIssueTrigger: .empty(), invoiceStateTrigger: .empty(), refreshTrigger: .empty(), loadNextPageTrigger: loadNextPageTrigger.asDriver(onErrorJustReturn: ()), loadingTrigger: .empty(), invoiceChanged: .empty()), api: EmployeesInvoicesServiceStub())
        viewModel.output.invoices
            .map({ (sections)  in
                sections[0].items.count
            })
            .drive(invoicesCount)
            .disposed(by: disposeBag)
        viewModel.output.isLoadingMore
            .drive(isLoadingMore)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(10, ()), .next(20, ())])
                   .bind(to: loadNextPageTrigger)
                   .disposed(by: disposeBag)
        
        
        scheduler.start()
        
        
        XCTAssertEqual(invoicesCount.events, [
            .next(0, 1),
            .next(10, 3),
            .next(20, 5)
          ])
        XCTAssertEqual(isLoadingMore.events, [
            .next(10, true),
            .next(20, true)
          ])
    }
    
    func testRefreshAfterLoadNext_invoicesCount_one(){
        let loadNextPageTrigger =  PublishRelay<Void>()
        let refreshTrigger =  PublishRelay<Void>()
        let invoicesCount = scheduler.createObserver(Int.self)
        let isRefreshing = scheduler.createObserver(Bool.self)
        let viewModel = EmployeesInvoicesViewModel(input: (periodOfIssueTrigger: .empty(), invoiceStateTrigger: .empty(), refreshTrigger: refreshTrigger.asDriver(onErrorJustReturn: ()), loadNextPageTrigger: loadNextPageTrigger.asDriver(onErrorJustReturn: ()), loadingTrigger: .empty(), invoiceChanged: .empty()), api: EmployeesInvoicesServiceStub())
        viewModel.output.invoices
            .map({ (sections)  in
                sections[0].items.count
            })
            .drive(invoicesCount)
            .disposed(by: disposeBag)
        viewModel.output.isRefreshing
            .drive(isRefreshing)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(10, ())])
                   .bind(to: loadNextPageTrigger)
                   .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(20, ())])
                   .bind(to: refreshTrigger)
                   .disposed(by: disposeBag)

        
        scheduler.start()
        
        
        XCTAssertEqual(invoicesCount.events, [
            .next(0, 1),
            .next(10, 3),
            .next(20, 1)
          ])
        XCTAssertEqual(isRefreshing.events, [
            .next(20, true)
          ])
    }
    
}


class EmployeesInvoicesServiceStub: InvoicesAPI {
    func update(invoice: Invoice, url: URL?) -> Single<Invoice> {
        return Single.create{ (single) -> Disposable in
            single(.success(Invoice(id: 1, periodOfIssue: "2020", state: .approved, value: "200", filename: nil, userWorkType: .agreement, user: nil)))
            return Disposables.create()
        }
    }
    
    func fetch(page: Int, userId: Int?, periodOfIssue: Date?, state: InvoiceState?) -> Single<InvoicesResponse> {
        return Single.create{ (single) -> Disposable in
            if page == 1 {
                single(.success([Invoice(id: 1, periodOfIssue: "2020-07", state: .approved, value: "200", filename: nil, userWorkType: .agreement, user: UserDetail(id: 1, name: "AA", surname: "BB", jobTitle: .accounts, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: nil))]))
            }
            if page == 2 {
                single(.success([Invoice(id: 2, periodOfIssue: "2020-06", state: .paid, value: "200", filename: nil, userWorkType: .agreement, user: nil), Invoice(id: 3, periodOfIssue: "2020-05", state: .paid, value: "200", filename: nil, userWorkType: .agreement, user: UserDetail(id: 1, name: "AA", surname: "BB", jobTitle: .accounts, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: nil))]))
            }
            if page == 3 {
                single(.success([Invoice(id: 4, periodOfIssue: "2020-04", state: .paid, value: "200", filename: nil, userWorkType: .agreement, user: nil), Invoice(id: 3, periodOfIssue: "2020-03", state: .paid, value: "200", filename: nil, userWorkType: .agreement, user: UserDetail(id: 1, name: "AA", surname: "BB", jobTitle: .accounts, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: nil))]))
            }
            return Disposables.create()
        }
    }
    
    func detail(id: Int) -> Single<Invoice> {
        return Single.create{ (single) -> Disposable in
            single(.success(Invoice(id: 1, periodOfIssue: "2020", state: .approved, value: "200", filename: nil, userWorkType: .agreement, user: nil)))
            return Disposables.create()
        }
    }
    
    
}

