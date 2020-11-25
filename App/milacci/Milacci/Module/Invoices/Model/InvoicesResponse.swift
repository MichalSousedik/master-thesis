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
    let totalHours: Double?
    let value: String?
    var filename: String?
    var userWorkType: WorkType?
    let user: UserDetail?
}

extension Invoice {

    var formattedPeriodOfIssue: String {
        let parts = periodOfIssue.components(separatedBy: "-")
        let year = parts[0]
        let month = parts[1].month
        return "\(month) \(year)"
    }

    var chartPeriodOfIssue: String {
        let parts = periodOfIssue.components(separatedBy: "-")
        let year = parts[0]
        let month = parts[1]
        return "\(month)-\(year)"
    }

}

extension Invoice {
    init(_ invoice: Invoice, state: InvoiceState? = nil) {
            self = Invoice(
                id: invoice.id,
                periodOfIssue: invoice.periodOfIssue,
                state: state ?? invoice.state,
                totalHours: invoice.totalHours,
                value: invoice.value,
                filename: invoice.filename,
                userWorkType: invoice.userWorkType,
                user: invoice.user
            )
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

enum InvoiceState: String, Codable, CaseIterable {
    case notIssued = "notIssued"
    case paid = "paid"
    case waiting = "waiting"
    case approved = "approved"
}

extension InvoiceState {

    var description: String {
        switch self {
        case .notIssued: return L10n.new
        case .paid: return L10n.paid
        case .approved:return L10n.approved
        case .waiting: return L10n.waiting
        }
    }

    var allowedTransitions: [InvoiceState] {
        switch self {
        case .notIssued: return []
        case .paid: return [.approved, .notIssued]
        case .approved:return [.paid, .notIssued]
        case .waiting: return [.approved, .paid, .notIssued]
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .notIssued: return UIColor.gray
        case .paid: return Asset.Colors.chartBarDefault.color
        case .approved: return Asset.Colors.primary1.color
        case .waiting: return UIColor.white
        }
    }

    var segmentedControlOrder: Int {
        switch self {
        case .notIssued: return 2
        case .paid: return 3
        case .approved: return 1
        case .waiting: return 0
        }
    }

}

typealias InvoicesResponse = [Invoice]

