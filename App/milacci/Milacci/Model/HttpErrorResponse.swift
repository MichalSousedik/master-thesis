//
//  SignInModelErrorResponse.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

struct HttpErrorResponse: Codable {
    let error: HttpErrorDetail
}

struct HttpErrorDetail: Codable {
    let message: String
    let status: Int
    let errorCode, errorClass, stack: String
}

