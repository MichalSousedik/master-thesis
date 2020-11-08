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
    func uploadFile(id: Int, url: URL) -> Single<String>
    func fetchInvoices(page: Int, userId: Int?) -> Single<InvoicesResponse>
    func fetchInvoice(id: Int) -> Single<Invoice>
}

class InvoiceService: InvoicesAPI {

    static let shared: InvoiceService = InvoiceService()
    private lazy var httpService = InvoiceHttpService()

    func uploadFile(id: Int, url: URL) -> Single<String> {
        return Single.create{ (single) -> Disposable in

            if url.startAccessingSecurityScopedResource() {
                let fileName = url.lastPathComponent
                let docData = try! Data(contentsOf: url)
                let params = [
                    "type": "invoice",
                    "invoiceId": id,
                    "sheet": docData
                ] as [String: Any]
                url.stopAccessingSecurityScopedResource()
                do {
                    let urlTo = try "https://httpbin.org/post".asURL()
                    AF.upload(multipartFormData: { [docData, fileName] multiPart in
                        for (key, value) in params {
                            if let temp = value as? String,
                               let data = temp.data(using: .utf8){
                                multiPart.append(data, withName: key)
                            }
                            if let temp = value as? Int,
                               let data = "\(temp)".data(using: .utf8){
                                multiPart.append(data, withName: key)
                            }
                        }
                        multiPart.append(docData, withName: "sheet", fileName: fileName, mimeType: "application/pdf")
                    }, to: urlTo)
                    .validate(statusCode: 200..<299)
                    .responseJSON { (result) in
                        if let error = result.error {
                            single(.error(error))
                        } else {
                            debugPrint(result)
                            single(.success("Hello"))
                        }
                    }

                }catch {
                    single(.error(NetworkingError.serverError(error)))
                }
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
