//
//  InvoicesRouter.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

struct InvoicesHttpRouter: HttpRouter {
    
    let path: String = "invoices"
    let method = HTTPMethod.get
    let limit = 10
    let order = "-createdAt"
    
    var userId: Int
    var offset: Int
    var parameters: Parameters? {
        var params = Parameters()
        params["userId"]=userId
        params["limit"]=limit
        params["offset"]=offset
        params["order"]=order
        return params
    }
    
    
}
