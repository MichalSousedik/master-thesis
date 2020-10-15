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
    func body() throws -> Data?
    
    func request(usingHttpService: HttpService) throws -> DataRequest
    
}

extension HttpRouter {
    
    var parameters: Parameters? { return nil }
    func body() throws -> Data? { return nil }
    var headers: HTTPHeaders? { return nil }
    var baseUrlString: String { return "https://private-a1268e-milacci1.apiary-mock.com/api/v1/" }
    
    func asUrlRequest() throws -> URLRequest {
        var url = try baseUrlString.asURL()
        url.appendPathComponent(path)
        var request = try URLRequest(url: url, method: method, headers: headers)
        try? request = URLEncoding().encode(request, with: parameters)
        request.httpBody = try body()
        return request
    }
    
    func request(usingHttpService service: HttpService) throws -> DataRequest {
        return try service.request(asUrlRequest())
    }
    
}
