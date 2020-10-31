//
//  InvoiceDetailHttpRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 27/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

struct InvoiceDetailHttpRouter: HttpRouter {

    private var accessToken: String {
        return UserSettingsService.shared.accessToken ?? ""
    }

    var id: Int

    var path: String {
        return "invoices/\(id)"
    }

    var method = HTTPMethod.get

    var headers: HTTPHeaders? {
        return [
            "Content-type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }

}
