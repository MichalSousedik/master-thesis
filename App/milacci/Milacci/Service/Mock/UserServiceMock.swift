//
//  UserService+Mock.swift
//  Milacci
//
//  Created by Michal Sousedik on 02/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import OHHTTPStubs

class UserServiceMock {

    static func allEmployees() {
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains("users") ?? false) && (urlRequest.url?.absoluteString.contains("teamLeaderId") == false)
        }) { (urlRequest) -> HTTPStubsResponse in

            if(urlRequest.url?.queryParameters?["offset"] == "0") {
                return HTTPStubsResponse(
                    fileAtPath: OHPathForFile("employees.geojson", self)!,
                    statusCode: 200,
                    headers: ["Content-Type": "application/json"]
                )
            } else {
                return HTTPStubsResponse(jsonObject: [], statusCode: 200, headers: nil)
                    .requestTime(0.0, responseTime: 0.0)
            }
        }
    }

    static func broPopDetail() {
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains("users") ?? false) && (urlRequest.url?.absoluteString.contains("63") == true)
        }) { (urlRequest) -> HTTPStubsResponse in
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("bro-pop.geojson", self)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )

        }
    }

    static func myTeam() {
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains("users") ?? false) && (urlRequest.url?.absoluteString.contains("teamLeaderId") ?? false)
        }) { (urlRequest) -> HTTPStubsResponse in

            if(urlRequest.url?.queryParameters?["offset"] == "0") {
                return HTTPStubsResponse(
                    fileAtPath: OHPathForFile("my-team.geojson", self)!,
                    statusCode: 200,
                    headers: ["Content-Type": "application/json"]
                )
            } else {
                return HTTPStubsResponse(jsonObject: [], statusCode: 200, headers: nil)
                    .requestTime(0.0, responseTime: 0.0)
            }
        }
    }

    static func myTeamSearched() {
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains("users") ?? false)
                && (urlRequest.url?.absoluteString.contains("teamLeaderId") ?? false)
                && (urlRequest.url?.absoluteString.contains("fullName") ?? false)
        }) { (urlRequest) -> HTTPStubsResponse in

            if(urlRequest.url?.queryParameters?["offset"] == "0") {
                return HTTPStubsResponse(
                    fileAtPath: OHPathForFile("my-team-searched.geojson", self)!,
                    statusCode: 200,
                    headers: ["Content-Type": "application/json"]
                )
            } else {
                return HTTPStubsResponse(jsonObject: [], statusCode: 200, headers: nil)
                    .requestTime(0.0, responseTime: 0.0)
            }
        }
    }

    static func detail() {
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("users") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in

            let jsonObject = [
                "id": 1001,
                "name": "Mate",
                "surname": "Dragon",
                "degree": "Mgr",
                "jobTitle": "backend",
                "dateOfBirth": "2000-07-20",
                "hourlyCapacity": 160,
                "phoneNumber": "733 000 121",
                "contactEmail": "mate.dragon@ack.ee",
                "workType": "registrationNumber",
                "hourRates": [
                    [
                        "id": 69,
                        "userId": 94,
                        "createdById": 96,
                        "since": "2020-02-24T23:00:00.000Z",
                        "type": "original",
                        "value": 300,
                        "percentageIncrease": 20,
                        "createdAt": "2020-02-25T15:18:04.000Z",
                        "updatedAt": "2020-02-25T15:18:04.000Z"
                    ],
                    [
                        "id": 62,
                        "userId": 94,
                        "createdById": 5,
                        "since": "2020-02-05T23:00:00.000Z",
                        "validTo": "2020-02-24T23:00:00.000Z",
                        "type": "original",
                        "value": 250,
                        "percentageIncrease": 0,
                        "createdAt": "2020-01-24T13:58:33.000Z",
                        "updatedAt": "2020-02-25T15:18:04.000Z"
                    ],
                    [
                        "id": 60,
                        "userId": 94,
                        "createdById": 96,
                        "since": "2020-01-02T23:59:59.000Z",
                        "validTo": "2020-02-05T23:00:00.000Z",
                        "type": "original",
                        "value": 250,
                        "percentageIncrease": -50,
                        "createdAt": "2020-01-21T16:34:12.000Z",
                        "updatedAt": "2020-01-24T13:58:33.000Z"
                    ],
                    [
                        "id": 57,
                        "userId": 94,
                        "createdById": 96,
                        "since": "2020-01-01T23:59:59.000Z",
                        "validTo": "2020-01-01T23:59:59.000Z",
                        "type": "original",
                        "value": 500,
                        "percentageIncrease": 0,
                        "createdAt": "2020-01-20T13:28:17.000Z",
                        "updatedAt": "2020-01-20T13:28:37.000Z"
                    ],
                    [
                        "id": 58,
                        "userId": 94,
                        "createdById": 96,
                        "since": "2020-01-01T23:59:59.000Z",
                        "validTo": "2020-01-02T23:59:59.000Z",
                        "type": "original",
                        "value": 500,
                        "percentageIncrease": 0,
                        "createdAt": "2020-01-20T13:28:37.000Z",
                        "updatedAt": "2020-01-21T16:34:12.000Z"
                    ]
                ],
            ] as [String: Any]

            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                .requestTime(0.0, responseTime: 0.0)
        }

    }

    static var count = 0
    static func fetch(){
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains("users") ?? false) && (urlRequest.url?.absoluteString.contains("limit") ?? false)
        }) { (urlRequest) -> HTTPStubsResponse in
            var jsonObject: [[String: Any]] = []
            if(urlRequest.url?.queryParameters?["offset"] == "0"){
                jsonObject = [
                    [
                        "id": 11,
                        "name": "Maten",
                        "surname": "Dragon"
                    ],
                    [
                        "id": 12,
                        "name": "Mateen",
                        "surname": "Dragoo"
                    ],
                    [
                        "id": 13,
                        "name": "Jane",
                        "surname": "Austen"
                    ]
                ]
            }
            if(urlRequest.url?.queryParameters?["offset"] == "15"){
                jsonObject = [
                    [
                        "id": 14,
                        "name": "Ernest",
                        "surname": "Dragon"
                    ],
                    [
                        "id": 15,
                        "name": "Albert",
                        "surname": "Dragoo"
                    ],
                    [
                        "id": 16,
                        "name": "Dave",
                        "surname": "Austen"
                    ]
                ]
            }
            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                .requestTime(0.0, responseTime: 0.0)

        }
    }
    static func update(model: UserDetail){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("users/limit") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            return HTTPStubsResponse(data: try! JSONEncoder().encode(model), statusCode: 200, headers: [:])
        }
    }
}
