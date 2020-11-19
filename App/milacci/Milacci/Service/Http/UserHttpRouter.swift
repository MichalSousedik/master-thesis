//
//  UserHttpRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 02/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

enum UserHttpRouter {
    case fetch(offset: Int, teamLeaderId: Int? = nil, searchedText: String? = nil)
    case detail(id: Int)
    case update(userDetail: UserDetail)
}

extension UserHttpRouter: HttpRouter {

    var path: String {
        switch self {
        case .fetch:
            return "users"
        case .detail(let id):
            return "users/\(id)"
        case .update(let userDetail):
            return "users/\(userDetail.id)"
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
        return [
            "Content-type": "application/json",
        ]
    }
    var parameters: Parameters? {
        switch self {
        case .fetch(let offset, let teamLeaderId, let searchedText):
            var params = Parameters()
            if let teamLeaderId = teamLeaderId {
                params["teamLeaderId"] = teamLeaderId
            }
            if let searchedText = searchedText {
                params["fullName"] = searchedText
            }
            params["limit"]=10
            params["offset"]=offset
            params["order"]="surname"
            return params
        default:
            return nil
        }
    }

    func body() throws -> Data? {
        switch self {
        case .update(let userDetail):
            return try? JSONEncoder().encode(userDetail)
        default:
            return nil
        }
    }

    var requestInterceptor: RequestInterceptor? { return AccessTokenInterceptor(userSettingsAPI: UserSettingsService.shared) }

}
