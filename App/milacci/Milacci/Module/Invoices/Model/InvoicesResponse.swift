//
//  InvoicesResponse.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

// MARK: - SignInModelElement
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
        case "01" : return "Leden";
        case "02" : return "Únor";
        case "03" : return "Březen";
        case "04" : return "Duben";
        case "05" : return "Květen";
        case "06" : return "Červen";
        case "07" : return "Červenec";
        case "08" : return "Srpen";
        case "09" : return "Září";
        case "10" : return "Říjen";
        case "11" : return "Listopad";
        case "12" : return "Prosinec";
        default: return "";
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
            case .notIssued: return "Nová"
            case .paid: return "Zaplacená"
            case .approved: return "Schválená"
            case .waiting: return "Čekající"
        }
    }
    
}

enum WorkType: String, Codable {
    case agreement = "agreement"
    case registrationNumber = "registrationNumber"
}

typealias InvoicesResponse = [Invoice]

