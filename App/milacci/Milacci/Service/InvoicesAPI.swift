//
//  InvoicesAPI.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift

protocol InvoicesAPI {
    func fetchInvoices(userId: Int, page: Int) -> Single<InvoicesResponse>
    func fetchInvoice(id: Int) -> Single<Invoice>
}
