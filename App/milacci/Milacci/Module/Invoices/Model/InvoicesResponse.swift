//
//  InvoicesResponse.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

struct Invoice: Codable {
    let id: Int
    let periodOfIssue: String
    let state: InvoiceState
    let totalHours: Int?
    let userWorkType: WorkType?
    let value: String?
    let filename: String?
}

extension Invoice {

    var formattedPeriodOfIssue: String {
        let parts = periodOfIssue.components(separatedBy: "-")
        let year = parts[0]
        let month = self.numberToMonth(parts[1])
        return "\(month) \(year)"
    }

    func numberToMonth(_ monthNumber: String) -> String {
        switch(monthNumber){
        case "01" : return NSLocalizedString("January", comment: "")
        case "02" : return NSLocalizedString("February", comment: "")
        case "03" : return NSLocalizedString("March", comment: "")
        case "04" : return NSLocalizedString("April", comment: "")
        case "05" : return NSLocalizedString("May", comment: "")
        case "06" : return NSLocalizedString("June", comment: "")
        case "07" : return NSLocalizedString("July", comment: "")
        case "08" : return NSLocalizedString("August", comment: "")
        case "09" : return NSLocalizedString("September", comment: "")
        case "10" : return NSLocalizedString("October", comment: "")
        case "11" : return NSLocalizedString("November", comment: "")
        case "12" : return NSLocalizedString("December", comment: "")
        default: return NSLocalizedString("Unknown month", comment: "")
        }
    }
}

extension Invoice: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Invoice: Equatable {
    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return lhs.id == rhs.id
    }
}

enum InvoiceState: String, Codable {
    case notIssued = "notIssued"
    case paid = "paid"
    case waiting = "waiting"
    case approved = "approved"
}

extension InvoiceState {

    var description: String {
        switch self{
        case .notIssued: return NSLocalizedString("New", comment: "")
        case .paid: return NSLocalizedString("Paid", comment: "")
        case .approved:return NSLocalizedString("Approved", comment: "")
        case .waiting: return NSLocalizedString("Waiting", comment: "")
        }
    }

}

enum WorkType: String, Codable {
    case agreement = "agreement"
    case registrationNumber = "registrationNumber"
}

typealias InvoicesResponse = [Invoice]

