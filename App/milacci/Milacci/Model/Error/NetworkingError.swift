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
    case custom(message: String)
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .deviceIsOffline:
            return NSLocalizedString("Device is offline", comment: "")
        case .unauthorized:
            return NSLocalizedString("Account was not authorized", comment: "")
        case .resourceNotFound:
            return NSLocalizedString("Resource was not found", comment: "")
        case .serverError(let error):
            return "\(NSLocalizedString("Server got into trouble", comment: "")) \(error.localizedDescription)"
        case .missingData:
            return NSLocalizedString("Searched data couldn't be located", comment: "")
        case .decodingFailed:
            return NSLocalizedString("Received data couldn't be loaded because they are in a wrong format", comment: "")
        case .custom(let message):
            return "\(NSLocalizedString("Fetching data resulted in error", comment: "")) \(message)"
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
