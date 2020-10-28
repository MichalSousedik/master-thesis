//
//  CustomError.swift
//  Milacci
//
//  Created by Michal Sousedik on 23/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//
import Foundation

enum NetworkingError: Error {
    case deviceIsOffline
    case unauthorized
    case resourceNotFound
    case serverError(Error)
    case missingData
    case decodingFailed(Error)
    case custom(message: String);
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .deviceIsOffline:
            return "Nelze se připojit k síti"
        case .unauthorized:
            return "Váš učet se nepodařilo autorizovat"
        case .resourceNotFound:
            return "Zdroj dat se nepodařilo lokalizovat"
        case .serverError(let error):
            return "Náš server se dostal do potíží: \(error.localizedDescription)"
        case .missingData:
            return "Vyhledávaná data neexistují"
        case .decodingFailed:
            return "Obdžená data nebyla načtena, neboť nejsou ve správném formátu"
        case .custom(let message):
            return "Získávání dat ze serveru se nepodařilo dokončit: \(message)"
        }
    }
}

extension NetworkingError: CategorizedError {
    var category: ErrorCategory {
        switch self {
        case .deviceIsOffline, .serverError:
            return .retryable
        case .resourceNotFound, .missingData, .decodingFailed, .custom:
            return .nonRetryable
        case .unauthorized:
            return .requiresLogout
        }
    }
}
