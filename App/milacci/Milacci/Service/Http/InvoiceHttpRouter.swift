//
//  InvoicesRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

enum InvoiceHttpRouter {
    case fetch(offset: Int, userId: Int? = nil)
    case detail(id: Int)
}

extension InvoiceHttpRouter: HttpRouter {

    var path: String {
        switch self {
        case .fetch:
            return "invoices"
        case .detail(let id):
            return "invoices/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetch: return .get
        case .detail: return .get
        }
    }

    var headers: HTTPHeaders? {
        return [
            "Content-type": "application/json",
        ]
    }

    var parameters: Parameters? {
        switch self {
        case .fetch(let offset, let userId):
            var params = Parameters()
            if let userId = userId {
                params["userId"] = userId
            }
            params["limit"]=10
            params["offset"]=offset
            params["order"]="-createdAt"
            return params
        default:
            return nil
        }

    }

    var requestInterceptor: RequestInterceptor? { return AccessTokenInterceptor(userSettingsAPI: UserSettingsService.shared) }

}
