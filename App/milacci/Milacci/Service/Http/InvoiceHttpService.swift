//
//  InvoicesSerivce.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

class InvoiceHttpService: HttpService {

    var sessionManager: Session = Session.default

    func request(_ urlRequest: URLRequestConvertible, requestInterceptor: RequestInterceptor?) -> DataRequest {
        return sessionManager.request(urlRequest, interceptor: requestInterceptor).validate(statusCode: 200..<400)
    }

}
