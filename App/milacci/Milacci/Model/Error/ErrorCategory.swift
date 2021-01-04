//
//  ErrorCategory.swift
//  Milacci
//
//  Created by Michal Sousedik on 25/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

enum ErrorCategory {
    case nonRetryable
    case retryable
}

protocol CategorizedError: Error {
    var category: ErrorCategory { get }
}
