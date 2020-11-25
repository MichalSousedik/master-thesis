//
//  InvoicesRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

enum InvoiceHttpRouter {
    case fetch(offset: Int, userId: Int? = nil, periodOfIssue: Date?, state: InvoiceState?)
    case detail(id: Int)
    case update(invoice: Invoice, url: URL? = nil)
}

extension InvoiceHttpRouter: HttpRouter {

    var path: String {
        switch self {
        case .fetch:
            return "invoices"
        case .detail(let id):
            return "invoices/\(id)"
        case .update(let invoice, _):
            return "invoices/\(invoice.id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetch: return .get
        case .detail: return .get
        case .update: return .put
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .fetch: return [
            "Content-type": "application/json",
        ]
        case .detail: return [
            "Content-type": "application/json",
        ]
        case .update: return [
            "Content-type": "multipart/form-data",
        ]
        }
    }

    var parameters: Parameters? {
        switch self {
        case .fetch(let offset, let userId, let periodOfIssue, let state):
            var params = Parameters()
            if let userId = userId {
                params["userId"] = userId
            }
            params["limit"]=10
            params["offset"]=offset
            params["order"]="-createdAt"
            if let periodOfIssue = periodOfIssue {
                params["periodOfIssue"]=periodOfIssue.periodFormat
            }
            if let state = state {
                params["state"]=state
            }
            params["limit"]=10
            return params
        default:
            return nil
        }
    }

    var multipartParameters: MultipartParameters? {
        switch self {
        case .fetch: return [:]
        case .detail: return [:]
        case .update(let invoice, let url):
            var params = ["state": invoice.state.rawValue] as [String: Any]
            if let url = url {
                params["file"] = url
            }
            return params
        }
    }

    var requestInterceptor: RequestInterceptor? { return AccessTokenInterceptor(userSettingsAPI: UserSettingsService.shared) }

}
