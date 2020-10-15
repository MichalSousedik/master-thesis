//
//  InvoicesService.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import RxSwift
import OHHTTPStubs
import Alamofire

class InvoicesService: InvoicesAPI {
    
    static let shared: InvoicesService = InvoicesService()
    private lazy var httpService = InvoicesHttpSerivce()
    
    
    func fetchInvoice(id: Int) -> Single<Invoice> {
        InvoicesService.mockInvoiceEndpoint()
        return Single.create{ [httpService] (single) -> Disposable in
            
            do {
                try InvoiceDetailHttpRouter(id: id)
                    .request(usingHttpService: httpService)
                    .responseJSON{ result in
                        do {
                            let invoice = try InvoicesService.parseInvoiceDetail(result: result)
                            single(.success(invoice))
                        } catch {
                            single(.error(error))
                        }
                }
            } catch {
                single(.error(CustomError.error(message: "InvoiceDetail fetch failed")))
            }
            
            return Disposables.create()
        }
    }
    
    func fetchInvoices(userId: Int, page: Int) -> Single<InvoicesResponse> {
        InvoicesService.mockInvoicesEndpoint()
        return Single.create{ [httpService] (single) -> Disposable in
            
            do {
                try InvoicesHttpRouter(userId: userId, offset: page)
                    .request(usingHttpService: httpService)
                    .responseJSON{ result in
                        do {
                            let invoices = try InvoicesService.parseInvoices(result: result)
                            single(.success(invoices))
                        } catch {
                            single(.error(error))
                        }
                }
            } catch {
                single(.error(CustomError.error(message: "Invoices fetch failed")))
            }
            
            return Disposables.create()
        }
    }
    
}

extension InvoicesService {
    
    static func parseInvoices(result: AFDataResponse<Any>) throws -> InvoicesResponse {
        guard
            let data = result.data,
            let invoicesResponse = try? JSONDecoder().decode(InvoicesResponse.self, from : data)
            else {
                throw CustomError.error(message: "Invalid Invoices response JSON")
        }
        return invoicesResponse
    }
    
    
    static func parseInvoiceDetail(result: AFDataResponse<Any>) throws -> Invoice {
        guard
            let data = result.data,
            let invoice = try? JSONDecoder().decode(Invoice.self, from : data)
            else {
                throw CustomError.error(message: "Invalid InvoiceDetail JSON")
        }
        return invoice
    }
    
}

extension InvoicesService {
    static var countInvoices = 0;
    static func mockInvoicesEndpoint(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("\(InvoicesHttpRouter(userId:1, offset: 1).baseUrlString)invoices") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            countInvoices+=1
            var jsonObject: [[String: Any]] = []
            if(urlRequest.url?.queryParameters?["offset"] == "1"){
                jsonObject = [
                ["id": 1,
                 "month": "Kveten",
                 "year": 2019,
                 "state": "waiting",
                 "filename": "my-invoice.pdf7",
                 "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                 "value": 205000],
                ["id": 2,
                 "month": "Duben",
                 "year": 2019,
                 "state": "approved",
                 "filename": "my-invoice.pdf",
                 "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                 "value": 30000],
                ["id": 3,
                 "month": "Brezen",
                 "year": 2019,
                 "state": "notIssued",
                 "value": 33000],
                ["id": 4,
                                   "month": "Unor",
                                   "year": 2019,
                                   "state": "approved",
                                   "value": 40000],
                ["id": 4,
                                                    "month": "Unor",
                                                    "year": 2019,
                                                    "state": "approved",
                                                    "value": 40000]
                
            ]
//                jsonObject += jsonObject
            }
            if(urlRequest.url?.queryParameters?["offset"] == "2"){
                jsonObject = [
                    ["id": 11,
                     "month": "A",
                     "year": 2019,
                     "state": "waiting",
                     "filename": "my-invoice.pdf7",
                     "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                     "value": 205000],
                    ["id": 12,
                     "month": "B",
                     "year": 2019,
                     "state": "approved",
                     "filename": "my-invoice.pdf",
                     "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                     "value": 30000],
                    ["id": 3,
                     "month": "C",
                     "year": 2019,
                     "state": "notIssued",
                     "value": 33000],
                    ["id": 4,
                                       "month": "D",
                                       "year": 2019,
                                       "state": "approved",
                                       "value": 40000],
                    ["id": 4,
                                                        "month": "E",
                                                        "year": 2019,
                                                        "state": "approved",
                                                        "value": 40000]
                    
                ]
            }
            if(urlRequest.url?.queryParameters?["offset"] == "3"){
                jsonObject = [
                    ["id": 11,
                     "month": "G",
                     "year": 2019,
                     "state": "waiting",
                     "filename": "my-invoice.pdf7",
                     "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                     "value": 205000],
                    ["id": 12,
                     "month": "H",
                     "year": 2019,
                     "state": "approved",
                     "filename": "my-invoice.pdf",
                     "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                     "value": 30000],
                    ["id": 3,
                     "month": "J",
                     "year": 2019,
                     "state": "notIssued",
                     "value": 33000],
                    ["id": 4,
                                       "month": "K",
                                       "year": 2019,
                                       "state": "approved",
                                       "value": 40000],
                    ["id": 4,
                                                        "month": "L",
                                                        "year": 2019,
                                                        "state": "approved",
                                                        "value": 40000]
                ]
            }
            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
//                .requestTime(1.0, responseTime: 3.0)
        }
    }
    
    static func mockInvoiceEndpoint(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("\(InvoicesHttpRouter(userId:1, offset: 1).baseUrlString)invoice") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            var jsonObject: [String: Any]
            if(urlRequest.url!.absoluteString.contains("1")){
                jsonObject =  ["id": 1,
                               "month": "Kveten",
                               "year": 2019,
                               "state": "waiting",
                               "filename": "my-invoice.pdf7",
                               "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                               "hours": 200,
                               "hourlyWage": 200,
                               "value": 205000]
            } else if (urlRequest.url!.absoluteString.contains("2")){
                jsonObject = ["id": 2,
                             "month": "Duben",
                             "year": 2019,
                             "state": "approved",
                             "filename": "my-invoice.pdf",
                             "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                             "hours": 180,
                             "hourlyWage": 300,
                             "value": 30000]
            } else {
                jsonObject = ["id": 3,
                               "month": "Brezen",
                               "year": 2019,
                               "state": "notIssued",
                               "hours": 100,
                               "hourlyWage": 450,
                               "value": 33000]
            }
            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
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
