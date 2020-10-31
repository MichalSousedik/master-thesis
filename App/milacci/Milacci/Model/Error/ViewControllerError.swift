//
//  ViewControllerError.swift
//  Milacci
//
//  Created by Michal Sousedik on 31/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

enum ViewControllerError: Error {
    case selectedUrlIsNotAccessible
}
extension ViewControllerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .selectedUrlIsNotAccessible:
            return L10n.selectedURLIsNotAccessible
        }
    }
}
