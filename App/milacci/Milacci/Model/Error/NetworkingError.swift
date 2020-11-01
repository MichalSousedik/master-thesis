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
    case forbiden
    case serverError(Error)
    case missingData
    case decodingFailed(Error)
    case custom(message: String)
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .deviceIsOffline:
            return L10n.deviceIsOffline
        case .unauthorized:
            return L10n.accountWasNotAuthorized
        case .resourceNotFound:
            return L10n.resourceWasNotFound
        case .serverError(let error):
            return "\(L10n.serverGotIntoTrouble) \(error.localizedDescription)"
        case .missingData:
            return L10n.searchedDataCouldnTBeLocated
        case .decodingFailed:
            return L10n.receivedDataCouldnTBeLoadedBecauseTheyAreInAWrongFormat
        case .forbiden:
            return L10n.forbidden
        case .custom(let message):
            return "\(L10n.fetchingDataResultedInError) \(message)"
        }
    }
}

extension NetworkingError: CategorizedError {
    var category: ErrorCategory {
        switch self {
        case .deviceIsOffline, .serverError:
            return .retryable
        case .resourceNotFound, .missingData, .forbiden, .decodingFailed, .custom:
            return .nonRetryable
        case .unauthorized:
            return .requiresLogout
        }
    }
}
