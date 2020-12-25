//
//  InvoiceHttpResponsesMock.swift
//  Milacci
//
//  Created by Michal Sousedik on 01/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import OHHTTPStubs
import Alamofire

extension InvoiceService {

    func mockInvoicesEndpoint(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("invoices?limit") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            var jsonObject: [[String: Any]] = []
            if(urlRequest.url?.queryParameters?["offset"] == "0"){
                let user = [
                    "id": 1,
                    "name": "D",
                    "surname": "M"
                ] as [String: Any]
                jsonObject = [
                    ["id": 1,
                     "periodOfIssue": "2020-10",
                     "state": "notIssued",
                     "user": user,
                     "value": "25000.00"],
                    ["id": 2,
                     "periodOfIssue": "2020-09",
                     "state": "waiting",
                     "filename": "my-invoice.pdf7",
                     "value": "10000.00"],
                    ["id": 3,
                     "periodOfIssue": "2020-08",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "15000.00"]
                ]
            }
            if(urlRequest.url?.queryParameters?["offset"] == "10"){
                jsonObject = [
                    ["id": 4,
                     "periodOfIssue": "2020-07",
                     "state": "paid",
                     "value": "20000.00"],
                    ["id": 5,
                     "periodOfIssue": "2020-06",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "60000.00"],
                    ["id": 6,
                     "periodOfIssue": "2020-05",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "33000.00"]
                ]
            }
            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                .requestTime(0.0, responseTime: 1.0)
        }
    }

    func mockInvoiceEndpoint(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("invoices") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            //                var jsonObject: [String: Any] = [:]
            //                if(urlRequest.url!.absoluteString.contains("1")){
            //                    jsonObject =  ["id": 1,
            //                                   "month": "Kveten",
            //                                   "year": 2019,
            //                                   "state": "waiting",
            //                                   "filename": "my-invoice.pdf7",
            //                                   "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
            //                                   "hours": 200,
            //                                   "hourlyWage": 200,
            //                                   "value": 205000]
            //                } else if (urlRequest.url!.absoluteString.contains("2")){
            //                    jsonObject = ["id": 2,
            //                                 "month": "Duben",
            //                                 "year": 2019,
            //                                 "state": "approved",
            //                                 "filename": "my-invoice.pdf",
            //                                 "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
            //                                 "hours": 180,
            //                                 "hourlyWage": 300,
            //                                 "value": 30000]
            //                } else {
            //                    jsonObject = ["id": 3,
            //                                   "month": "Brezen",
            //                                   "year": 2019,
            //                                   "state": "notIssued",
            //                                   "hours": 100,
            //                                   "hourlyWage": 450,
            //                                   "value": 33000]
            //                }
            return HTTPStubsResponse(jsonObject: [], statusCode: 403, headers: nil)
                .requestTime(1.0, responseTime: 3.0)
        }
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
