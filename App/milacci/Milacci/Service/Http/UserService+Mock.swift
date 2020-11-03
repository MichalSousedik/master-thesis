//
//  UserService+Mock.swift
//  Milacci
//
//  Created by Michal Sousedik on 02/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import OHHTTPStubs

extension UserService {

    func mockDetailEndpoint(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("users") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in

            let jsonObject = [
                "name": "Mate",
                "surname": "Dragon",
                "degree": "Mgr",
                "jobTitle": "backend",
                "dateOfBirth": "2000-07-20",
                "hourlyCapacity": 160,
                "phoneNumber": "733 000 121",
                "contactEmail": "mate.dragon@ack.ee",
                "workType": "registrationNumber"
            ] as [String: Any]

        return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
//            .requestTime(1.0, responseTime: 3.0)
    }
}

}
