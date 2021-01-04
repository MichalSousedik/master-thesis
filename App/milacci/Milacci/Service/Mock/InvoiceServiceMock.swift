//
//  InvoiceHttpResponsesMock.swift
//  Milacci
//
//  Created by Michal Sousedik on 01/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import OHHTTPStubs
import Alamofire

class InvoiceServiceMock {

    static var retry = 0

    static func unauthorizedAfterThreeRetries() {
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains(InvoiceHttpRouter.invoices) ?? false) && (urlRequest.url?.absoluteString.contains("limit") ?? false)
        }) { (urlRequest) -> HTTPStubsResponse in
            return HTTPStubsResponse(jsonObject: [], statusCode: 401, headers: nil)
        }
    }

    static func authorizedAfterTwoRetries() {
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains(InvoiceHttpRouter.invoices) ?? false) && (urlRequest.url?.absoluteString.contains("limit") ?? false)
        }) { (urlRequest) -> HTTPStubsResponse in
            if retry < 2 {
                retry += 1
                return HTTPStubsResponse(jsonObject: [], statusCode: 401, headers: nil)
            } else {
                return HTTPStubsResponse(jsonObject: [], statusCode: 200, headers: nil)
            }
        }
    }

    static func employeesInvoices(){
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains(InvoiceHttpRouter.invoices) ?? false) && (urlRequest.url?.absoluteString.contains("limit") ?? false)
        }) { (urlRequest) -> HTTPStubsResponse in

            if(urlRequest.url?.queryParameters?["offset"] == "0"){
                if urlRequest.url?.queryParameters?["state"] == "approved" {
                    return HTTPStubsResponse(
                        fileAtPath: OHPathForFile("employees-invoices-approved.geojson", self)!,
                        statusCode: 200,
                        headers: ["Content-Type": "application/json"]
                      )
                } else if urlRequest.url?.queryParameters?["state"] == "notIssued"{
                    return HTTPStubsResponse(
                        fileAtPath: OHPathForFile("employees-invoices-new.geojson", self)!,
                        statusCode: 200,
                        headers: ["Content-Type": "application/json"]
                    )
                } else {
                    return HTTPStubsResponse(
                        fileAtPath: OHPathForFile("employees-invoices.geojson", self)!,
                        statusCode: 200,
                        headers: ["Content-Type": "application/json"]
                      )
                }

            } else {
                return HTTPStubsResponse(jsonObject: [], statusCode: 200, headers: nil)
            }
        }
    }

    static func myInvoices(){
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains(InvoiceHttpRouter.invoices) ?? false) && (urlRequest.url?.absoluteString.contains("userId") ?? false)
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
                     "value": "15000.00"],
                    ["id": 4,
                     "periodOfIssue": "2020-7",
                     "state": "notIssued",
                     "user": user,
                     "value": "25000.00"],
                    ["id": 5,
                     "periodOfIssue": "2020-06",
                     "state": "waiting",
                     "filename": "my-invoice.pdf7",
                     "value": "10000.00"],
                    ["id": 6,
                     "periodOfIssue": "2020-05",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "15000.00"],
                    ["id": 7,
                     "periodOfIssue": "2020-04",
                     "state": "notIssued",
                     "user": user,
                     "value": "25000.00"],
                    ["id": 8,
                     "periodOfIssue": "2020-03",
                     "state": "waiting",
                     "filename": "my-invoice.pdf7",
                     "value": "10000.00"],
                    ["id": 9,
                     "periodOfIssue": "2020-02",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "15000.00"],
                    ["id": 10,
                     "periodOfIssue": "2020-01",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "15000.00"]
                ]
            }
            if urlRequest.url?.queryParameters?["offset"] == "\(InvoiceHttpRouter.limit)" {
                jsonObject = [
                    ["id": 11,
                     "periodOfIssue": "2019-12",
                     "state": "notIssued",
                     "value": "25000.00"],
                    ["id": 12,
                     "periodOfIssue": "2019-11",
                     "state": "waiting",
                     "filename": "my-invoice.pdf7",
                     "value": "10000.00"],
                    ["id": 13,
                     "periodOfIssue": "2019-10",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "15000.00"],
                    ["id": 14,
                     "periodOfIssue": "2019-09",
                     "state": "notIssued",
                     "value": "25000.00"],
                    ["id": 15,
                     "periodOfIssue": "2019-08",
                     "state": "waiting",
                     "filename": "my-invoice.pdf7",
                     "value": "10000.00"],
                    ["id": 16,
                     "periodOfIssue": "2019-07",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "15000.00"],
                    ["id": 17,
                     "periodOfIssue": "2019-06",
                     "state": "notIssued",
                     "value": "25000.00"],
                    ["id": 18,
                     "periodOfIssue": "2019-05",
                     "state": "waiting",
                     "filename": "my-invoice.pdf7",
                     "value": "10000.00"],
                    ["id": 19,
                     "periodOfIssue": "2019-04",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "15000.00"],
                    ["id": 20,
                     "periodOfIssue": "2019-03",
                     "state": "paid",
                     "filename": "my-invoice.pdf7",
                     "value": "15000.00"]
                ]
            }
            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
                .requestTime(0.0, responseTime: 0.0)
        }
    }

    static func detail(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains(InvoiceHttpRouter.invoices) ?? false && (urlRequest.url?.absoluteString.contains("limit") == false)
        }) { (urlRequest) -> HTTPStubsResponse in
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("invoice-detail.geojson", self)!,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
              )
        }
    }

    static func update(model: Invoice){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains(InvoiceHttpRouter.invoices) ?? false && urlRequest.httpMethod?.lowercased() == "put"
        }) { (urlRequest) -> HTTPStubsResponse in
            return HTTPStubsResponse(data: try! JSONEncoder().encode(model), statusCode: 200, headers: [:])

        }
    }

    static func fetchWithError(){
        stub(condition: {(urlRequest) -> Bool in
            return (urlRequest.url?.absoluteString.contains(InvoiceHttpRouter.invoices) ?? false)
        }) { (urlRequest) -> HTTPStubsResponse in
            let error = [
                "error": [
                    "message": "Databáze na serveru není dočasně dostupná."
                ]
            ]
            return HTTPStubsResponse(jsonObject: error, statusCode: 400, headers: nil)
                .requestTime(0.0, responseTime: 0.0)
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
