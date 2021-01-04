//
//  MockForUITests.swift
//  Milacci
//
//  Created by Michal Sousedik on 04/01/2021.
//  Copyright © 2021 Michal Sousedik. All rights reserved.
//

import Foundation

class MockForUITests {

    static func mock() {
        if CommandLine.arguments.contains("-withoutGoogleSignIn") {
          DisableGoogleSignIn.shared.disabled = true
        }
        if CommandLine.arguments.contains("-mockUser") {
          AuthServiceMock.signIn(role: "user")
          HourRateServiceMock.stats()
          UserServiceMock.detail()
          InvoiceServiceMock.myInvoices()
        }
        if CommandLine.arguments.contains("-mockTeamLeader") {
          AuthServiceMock.signIn(role: "teamLeader")
          UserServiceMock.myTeam()
          UserServiceMock.myTeamSearched()
          InvoiceServiceMock.myInvoices()
        }
        if CommandLine.arguments.contains("-mockAdmin") {
          AuthServiceMock.signIn(role: "admin")
          InvoiceServiceMock.employeesInvoices()
          InvoiceServiceMock.update(model: Invoice(id: 1025, periodOfIssue: "2020-05", state: .approved, value: nil, filename: nil, userWorkType: nil, user: nil))
          HourRateServiceMock.stats()
          HourRateServiceMock.create(model: HourRate(id: 1, since: "2030-07-20T00:00:00.000Z", validTo: nil, type: .original, value: 600, percentageIncrease: nil))
          UserServiceMock.allEmployees()
          UserServiceMock.broPopDetail()
          UserServiceMock.update(model: UserDetail(id: 63, name: "Broo", surname: "Popo", jobTitle: .accounts, degree: nil, dateOfBirth: nil, hourlyCapacity: nil, phoneNumber: nil, contactEmail: nil, workType: nil, hourRates: []))
        }
    }

}
