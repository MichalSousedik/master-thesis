//
//  InvoicesService.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol InvoicesAPI {
    func updateInvoice(invoice: Invoice, url: URL) -> Single<Invoice>
    func fetchInvoices(page: Int, userId: Int?) -> Single<InvoicesResponse>
    func fetchInvoice(id: Int) -> Single<Invoice>
}

class InvoiceService: InvoicesAPI {

    static let shared: InvoiceService = InvoiceService()
    private lazy var httpService = SecuredHttpService()

    func updateInvoice(invoice: Invoice, url: URL) -> Single<Invoice> {
        return Single.create{[httpService] (single) -> Disposable in
            do {
                try InvoiceHttpRouter.update(invoice: invoice, url: url)
                    .upload(usingHttpService: httpService)
                    .responseJSON{ result in
                        HttpResponseHandler.handle(result: result, completion: { (invoice, error) in
                            if let error = error {
                                single(.error(error))
                            } else if let invoice = invoice {
                                single(.success(invoice))
                            }
                        }, type: Invoice.self)
                    }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }
            return Disposables.create()
        }
    }

    func fetchInvoice(id: Int) -> Single<Invoice> {
        return Single.create{ [httpService] (single) -> Disposable in
            do {
                try InvoiceHttpRouter.detail(id: id)
                    .request(usingHttpService: httpService)
                    .responseJSON{ result in
                        HttpResponseHandler.handle(result: result, completion: { (invoice, error) in
                            if let error = error {
                                single(.error(error))
                            } else if let invoice = invoice {
                                single(.success(invoice))
                            }
                        }, type: Invoice.self)
                    }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }

            return Disposables.create()
        }
    }

    func fetchInvoices(page: Int, userId: Int? = nil) -> Single<InvoicesResponse> {
//        self.mockInvoicesEndpoint()
        return Single.create{ [httpService] (single) -> Disposable in
            do {
                try InvoiceHttpRouter.fetch(offset: (page - 1)*10, userId: userId)
                    .request(usingHttpService: httpService)
                    .responseJSON { result in
                        HttpResponseHandler.handle(result: result, completion: { (invoices, error) in
                            if let error = error {
                                single(.error(error))
                            } else if let invoices = invoices {
                                single(.success(invoices))
                            }
                        }, type: InvoicesResponse.self)
                    }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }

            return Disposables.create()
        }
    }

}
