//
//  HourRateService+Mock.swift
//  Milacci
//
//  Created by Michal Sousedik on 18/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import OHHTTPStubs

extension HourRateService {

    func mockCreate(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("hour-rates") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in

            let jsonObject = [
                "id": 69,
                        "userId": 94,
                        "createdById": 96,
                        "since": "2020-11-17T23:00:00.000Z",
                        "type": "original",
                        "value": 300,
                        "percentageIncrease": 20,
                        "createdAt": "2020-02-25T15:18:04.000Z",
                        "updatedAt": "2020-02-25T15:18:04.000Z"
                    ] as [String: Any]

            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                .requestTime(1.0, responseTime: 3.0)
        }

    }

    func mockFetch(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("users") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            let jsonObject: [String: Any] = [:]
        return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 500, headers: nil)
            .requestTime(1.0, responseTime: 3.0)
    }

}

}
