//
//  InvoicesSerivce.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

class SecuredHttpService: HttpService {

    var sessionManager: Session = Session.default

    func request(_ urlRequest: URLRequestConvertible, requestInterceptor: RequestInterceptor?) -> DataRequest {
        return sessionManager.request(urlRequest, interceptor: requestInterceptor).validate(statusCode: 200..<400)
    }

    func upload(_ urlRequest: URLRequestConvertible, multipartParameters: MultipartParameters, requestInterceptor: RequestInterceptor?) -> DataRequest {
        return sessionManager.upload(multipartFormData: { [multipartParameters] (multipartFormData) in
            for (key, value) in multipartParameters {
                if let temp = value as? String,
                   let data = temp.data(using: .utf8){
                    multipartFormData.append(data, withName: key)
                }
                if let temp = value as? Int,
                   let data = "\(temp)".data(using: .utf8){
                    multipartFormData.append(data, withName: key)
                }
                if let url = value as? URL,
                   url.startAccessingSecurityScopedResource(),
                   let urlData = try? Data(contentsOf: url) {
                    let fileName = url.lastPathComponent
                    multipartFormData.append(urlData, withName: key, fileName: fileName, mimeType: "application/pdf")
                    url.stopAccessingSecurityScopedResource()
                }
            }}, with: urlRequest, interceptor: requestInterceptor).validate(statusCode: 200..<400)
        }

        }
