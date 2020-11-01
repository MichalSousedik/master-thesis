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
            return urlRequest.url?.absoluteString.contains("invoices") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in

            //            if(urlRequest.url?.queryParameters?["offset"] == "3"){
            //                jsonObject = [
            //                    ["id": 11,
            //                     "month": "G",
            //                     "year": 2019,
            //                     "state": "waiting",
            //                     "filename": "my-invoice.pdf7",
            //                     "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
            //                     "value": 205000],
            //                    ["id": 12,
            //                     "month": "H",
            //                     "year": 2019,
            //                     "state": "approved",
            //                     "filename": "my-invoice.pdf",
            //                     "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
            //                     "value": 30000],
            //                    ["id": 3,
            //                     "month": "J",
            //                     "year": 2019,
            //                     "state": "notIssued",
            //                     "value": 33000],
            //                    ["id": 4,
            //                                       "month": "K",
            //                                       "year": 2019,
            //                                       "state": "approved",
            //                                       "value": 40000],
            //                    ["id": 4,
            //                                                        "month": "L",
            //                                                        "year": 2019,
            //                                                        "state": "approved",
            //                                                        "value": 40000]
            //                ]
            //            }
            return HTTPStubsResponse(jsonObject: [], statusCode: 500, headers: nil)
            //                .requestTime(1.0, responseTime: 3.0)
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
