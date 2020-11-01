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

class InvoiceService: InvoicesAPI {

    static let shared: InvoiceService = InvoiceService()
    private lazy var httpService = InvoiceHttpSerivce()

    func uploadFile(id: Int, url: URL) -> Single<String> {
        return Single.create{ (single) -> Disposable in
            AF.upload(url, to: "https://milacci2-api-development.ack.ee/api/v1/invoices/\(id)/file-urls", headers:
                        ["Authorization": "Bearer \(UserSettingsService.shared.accessToken ?? "")"])
                .responseJSON{ result in
                    HttpResponseHandler.handle(result: result, completion: { (item, error) in
                        if let error = error {
                            single(.error(error))
                        } else if let item = item {
                            single(.success(item))
                        }
                    }, type: String.self)
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

    func fetchInvoices(page: Int) -> Single<InvoicesResponse> {
        return Single.create{ [httpService] (single) -> Disposable in
            do {
                try InvoiceHttpRouter.fetch(offset: (page - 1)*10)
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
