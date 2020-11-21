//
//  HourRateHttpRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 17/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

enum HourRateHttpRouter {
    case create(value: Double, since: Date, userId: Int)
    case stats(period: Date)
}

extension HourRateHttpRouter: HttpRouter {

    var path: String {
        switch self {
        case .create:
            return "hour-rates"
        case .stats:
            return "hour-rate-stats"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .create: return .post
        case .stats: return .get
        }
    }

    var headers: HTTPHeaders? {
        return [
            "Content-type": "application/json",
        ]
    }

    var parameters: Parameters? {
        switch self {
        case .stats(let period):
            var params = Parameters()
            params["period"] = period.periodFormat
            return params
        default:
            return nil
        }
    }

    func body() throws -> Data? {
        switch self {
        case .create(let value, let since, let userId):
            let json: [String: Any] = ["value": value, "since": since.iso8601withFractionalSeconds, "userId": userId]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            return jsonData
        default: return nil
        }
    }

    var requestInterceptor: RequestInterceptor? { return AccessTokenInterceptor(userSettingsAPI: UserSettingsService.shared) }

}
