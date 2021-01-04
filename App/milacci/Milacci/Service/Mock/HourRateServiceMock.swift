//
//  HourRateService+Mock.swift
//  Milacci
//
//  Created by Michal Sousedik on 18/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import OHHTTPStubs

class HourRateServiceMock {

    static func create(model: HourRate){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("hour-rates") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            return HTTPStubsResponse(data: try! JSONEncoder().encode(model), statusCode: 200, headers: [:])
        }

    }

    static func stats(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("hour-rate-stats") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            let jsonObject = [
                "id": 69,
                "percentageIncrease": 20,
                "createdAt": "2020-02-25T15:18:04.000Z",
                "updatedAt": "2020-02-25T15:18:04.000Z"
            ] as [String: Any]
            return HTTPStubsResponse(jsonObject: [jsonObject], statusCode: 200, headers: nil)
                .requestTime(0.0, responseTime: 0.0)
        }

    }
}

