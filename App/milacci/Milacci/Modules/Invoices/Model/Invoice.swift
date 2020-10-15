//
//  Invoice.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation


typealias InvoicesResponse = [Invoice]

class Invoice: Codable {
    
    var id: Int
    var month: String
    var year: Int
    var filename: String?
    var fileUrl: String?
    var state: State
    var value: Int
    var hours: Int?
    var hourlyWage: Int?
    
}

extension Invoice {
    var date: String {
        return "\(month) \(year)"
    }
}

extension Invoice: Equatable {
    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Invoice: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum State: String, Codable {
    
    case waiting
    case notIssued
    case approved
    case paid

}

extension State {

    var description: String {
        switch self{
            case .notIssued: return "Nová"
            case .paid: return "Zaplacená"
            case .approved: return "Schválená"
            case .waiting: return "Čekající"
        }
    }
    
}
