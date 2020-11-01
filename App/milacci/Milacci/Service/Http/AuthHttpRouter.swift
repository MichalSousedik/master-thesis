//
//  AuthHttpRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 27/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

enum AuthHttpRouter {
    case authenticate(accessToken: String)
    case refreshToken(refreshToken: String)
}

extension AuthHttpRouter: HttpRouter {

//    var accessToken: String?

    var path: String {
        switch self {
        case .authenticate:
            return "auth/google/sign-in"
        case .refreshToken:
            return "auth/refresh"
        }
    }

    var method: HTTPMethod {
        .post
    }

    var headers: HTTPHeaders? {
        return [
            "Content-type": "application/json"
        ]
    }

    func body() throws -> Data? {
        switch self {
        case .authenticate(let accessToken):
            let json: [String: Any] = ["accessToken": accessToken]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            return jsonData
        case .refreshToken(let refreshToken):
            let json: [String: Any] = ["token": refreshToken]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            return jsonData
        }

    }

}
