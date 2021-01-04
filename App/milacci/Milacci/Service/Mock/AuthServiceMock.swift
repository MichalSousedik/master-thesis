//
//  AuthService+Mock.swift
//  Milacci
//
//  Created by Michal Sousedik on 28/12/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import OHHTTPStubs

class AuthServiceMock {

    static func signIn(role: String){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("auth/google/sign-in") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in

            let jsonObject =

                [ "user": [
                "id": 1,
                    "roles": [role]
                ],
                "credentials": [
                    "accessToken": "Ackee Access Token",
                    "refreshToken": "Refresh Token",
                    "expiresIn": 3600
                ]
            ] as [String: Any]

            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                .requestTime(0.0, responseTime: 0.0)
        }
    }

    static func signInError(statusCode: Int32, message: String){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("auth/google/sign-in") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            let error = [
                "error": [
                    "message": message
                ]
            ]
            return HTTPStubsResponse(jsonObject: error, statusCode: statusCode, headers: nil)
                .requestTime(0.0, responseTime: 0.0)
        }
    }

    static func refresh(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("auth/refresh") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in

            let jsonObject =

                [ "user": [
                "id": 1,
                    "roles": []
                ],
                "credentials": [
                    "accessToken": "New Ackee Access Token",
                    "refreshToken": "Refresh Token",
                    "expiresIn": 3600
                ]
            ] as [String: Any]

            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                .requestTime(0.0, responseTime: 0.0)
        }

    }
}
