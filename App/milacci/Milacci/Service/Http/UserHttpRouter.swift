//
//  UserHttpRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 02/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

enum UserHttpRouter {
    case detail(id: Int)
}

extension UserHttpRouter: HttpRouter {

    var path: String {
        switch self {
        case .detail(let id):
            return "users/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .detail: return .get
        }
    }

    var headers: HTTPHeaders? {
        return [
            "Content-type": "application/json",
        ]
    }

    var requestInterceptor: RequestInterceptor? { return AccessTokenInterceptor(userSettingsAPI: UserSettingsService.shared) }

}
