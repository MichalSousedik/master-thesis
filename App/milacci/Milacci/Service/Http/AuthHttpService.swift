//
//  AuthHttpService.swift
//  Milacci
//
//  Created by Michal Sousedik on 27/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

class AuthHttpService: HttpService {

    var sessionManager: Session = Session.default

    func request(_ urlRequest: URLRequestConvertible, requestInterceptor: RequestInterceptor?) -> DataRequest {
        return sessionManager.request(urlRequest).validate(statusCode: 200..<299)
    }

}
