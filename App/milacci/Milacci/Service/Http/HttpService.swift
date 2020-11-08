//
//  HttpService.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

typealias MultipartParameters = [String: Any]

protocol HttpService {
    var sessionManager: Session { get set }
    func request(_ urlRequest: URLRequestConvertible, requestInterceptor: RequestInterceptor?) -> DataRequest
    func upload(_ urlRequest: URLRequestConvertible, multipartParameters: MultipartParameters, requestInterceptor: RequestInterceptor?) -> DataRequest
}
