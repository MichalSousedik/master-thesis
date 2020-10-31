//
//  InvoiceDetailHttpRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 27/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

struct InvoiceDetailHttpRouter: HttpRouter {

    var id: Int

    var path: String {
        return "invoice/\(id)"
    }

    var method = HTTPMethod.get

}
