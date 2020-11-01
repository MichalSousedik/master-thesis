//
//  HttpRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import Alamofire

protocol HttpRouter {

    var baseUrlString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var requestInterceptor: RequestInterceptor? { get }
    func body() throws -> Data?

    func request(usingHttpService: HttpService) throws -> DataRequest

}

extension HttpRouter {

    var baseUrlString: String {
        let url = PlistFiles.apiBaseUrlEndpoint
        let version = PlistFiles.apiBaseUrlEndpointVersion
        return "\(url)/\(version)"
    }
    var parameters: Parameters? { return nil }
    func body() throws -> Data? { return nil }
    var headers: HTTPHeaders? { return nil }
    var requestInterceptor: RequestInterceptor? { return nil }

    func asUrlRequest() throws -> URLRequest {
        var url = try baseUrlString.asURL()
        url.appendPathComponent(path)
        var request = try URLRequest(url: url, method: method, headers: headers)
        try? request = URLEncoding().encode(request, with: parameters)
        request.httpBody = try body()
        return request
    }

    func request(usingHttpService service: HttpService) throws -> DataRequest {
        return try service.request(asUrlRequest(), requestInterceptor: requestInterceptor)
    }

}
