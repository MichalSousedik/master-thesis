//
//  AuthHttpRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 27/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

struct AuthHttpRouter: HttpRouter {

    var accessToken: String?

    let path: String = "auth/google/sign-in"
    let method = HTTPMethod.post

    var headers: HTTPHeaders? {
        return [
            "Content-type": "application/json"
        ]
    }

    func body() throws -> Data? {
        guard let accessToken = accessToken else { throw NetworkingError.custom(message: L10n.accessTokenNotProvided)}
        let json: [String: Any] = ["accessToken": accessToken]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        return jsonData
    }

}
