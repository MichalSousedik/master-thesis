//
//  ErrorResponse.swift
//  Milacci
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let error: ErrorDetail
}

struct ErrorDetail: Codable {
    let message: String
    let status: Int?
    let errorCode, errorClass, stack: String?
}
