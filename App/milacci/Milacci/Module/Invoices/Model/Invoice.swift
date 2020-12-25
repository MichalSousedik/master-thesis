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
    let value: String?
    var filename: String?
    var userWorkType: WorkType?
    let user: UserDetail?
}

extension Invoice {

    var overviewPeriodOfIssue: String {
        let parts = periodOfIssue.components(separatedBy: "-")
        guard parts.count == 2 else {
            return ""
        }
        let year = parts[0]
        let month = parts[1].month
        return "\(month) \(year)"
    }

    var chartPeriodOfIssue: String {
        let parts = periodOfIssue.components(separatedBy: "-")
        guard parts.count == 2 else {
            return ""
        }
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
                value: invoice.value,
                filename: invoice.filename,
                userWorkType: invoice.userWorkType,
                user: invoice.user
            )
        }
}

extension Invoice: Equatable {
    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return lhs.id == rhs.id && lhs.periodOfIssue == rhs.periodOfIssue && lhs.state == rhs.state
            && lhs.value == rhs.value && lhs.filename == rhs.filename && lhs.userWorkType == rhs.userWorkType
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

    var icon: String {
        switch self {
        case .notIssued: return "⏎"
        case .paid: return "$"
        case .approved: return "✓"
        case .waiting: return "⏳"
        }
    }

    var image: UIImage {
        switch self {
        case .notIssued: return UIImage(systemSymbol: .return)
        case .paid: return UIImage(systemSymbol: .dollarsignCircle)
        case .approved: return UIImage(systemSymbol: .checkmark)
        case .waiting: return UIImage(systemSymbol: .timer)
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

