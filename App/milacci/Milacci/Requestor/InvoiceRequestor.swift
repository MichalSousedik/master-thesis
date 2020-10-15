//
//  InvoiceRequestor.swift
//  Milacci
//
//  Created by Michal Sousedik on 16/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import Alamofire
import OHHTTPStubs


class InvoiceRequestor {
    
    static func fetch(completion: @escaping ([Invoice]?, AFError?) -> Void) {
        
        myStub()
        
        AF.request(InvoiceRouter.all).responseJSON { (response: AFDataResponse<Any>) in
            switch response.result {
            case .success(let value):
                if let jsonData = value as? [[String: Any]],
                    let data = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted){
                        let decoder = JSONDecoder()
                    do {
                        let invoices = try decoder.decode([Invoice].self, from: data)
                        completion(invoices, nil)

                    } catch {
                        print(error.localizedDescription)
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static func myStub(){
        stub(condition: {(urlRequest) -> Bool in
            return urlRequest.url?.absoluteString.contains("httpbin") ?? false
        }) { (urlRequest) -> HTTPStubsResponse in
            let jsonObject: [[String: Any]] = [
                ["id": 1,
                "state": "waiting",
                "filename": "my-invoice.pdf7",
                "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                "value": 205000],
                ["id": 2,
                "state": "approved",
                "filename": "my-invoice.pdf",
                "fileUrl": "https://files.milacci.ack.ee/my-invoice.pdf",
                "value": 30000],
                ["id": 3,
                "state": "notIssued",
                "value": 33000]
            ]
            return HTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
        }
    }
    
}
