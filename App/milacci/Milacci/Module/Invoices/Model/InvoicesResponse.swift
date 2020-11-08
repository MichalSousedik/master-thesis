//
//  InvoicesResponse.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import RxSwift

struct Invoice: Codable {
    let id: Int
    let periodOfIssue: String
    let state: InvoiceState
    let totalHours: Int?
    let value: String?
    var filename: String?
}

extension Invoice {

    var formattedPeriodOfIssue: String {
        let parts = periodOfIssue.components(separatedBy: "-")
        let year = parts[0]
        let month = self.numberToMonth(parts[1])
        return "\(month) \(year)"
    }

    var chartPeriodOfIssue: String {
        let parts = periodOfIssue.components(separatedBy: "-")
        let year = parts[0]
        let month = parts[1]
        return "\(month)-\(year)"
    }

    func numberToMonth(_ monthNumber: String) -> String {
        switch(monthNumber){
        case "01" : return L10n.january
        case "02" : return L10n.february
        case "03" : return L10n.march
        case "04" : return L10n.april
        case "05" : return L10n.may
        case "06" : return L10n.june
        case "07" : return L10n.july
        case "08" : return L10n.august
        case "09" : return L10n.september
        case "10" : return L10n.october
        case "11" : return L10n.november
        case "12" : return L10n.december
        default: return L10n.unknownMonth
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
        case .notIssued: return L10n.new
        case .paid: return L10n.paid
        case .approved:return L10n.approved
        case .waiting: return L10n.waiting
        }
    }

}

typealias InvoicesResponse = [Invoice]

