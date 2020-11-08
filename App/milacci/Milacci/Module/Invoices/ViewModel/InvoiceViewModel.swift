//
//  InvoiceCellViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxDataSources

typealias InvoiceItemsSection = SectionModel<Int, InvoiceViewPresentable>

protocol InvoiceViewPresentable {
    var date: String { get }
    var state: String { get }
    var canDownloadFile: Bool { get }
    var canUploadFile: Bool { get }
    var value: String { get }
    var invoice: Invoice { get }
    var infoMessage: String? { get }
}

struct InvoiceViewModel: InvoiceViewPresentable{
    var date: String
    var state: String
    var value: String
    var invoice: Invoice
    var canDownloadFile: Bool
    var canUploadFile: Bool
    var infoMessage: String?
}

extension InvoiceViewModel {

    init(withInvoice invoice: Invoice){
        self.invoice = invoice
        self.state = invoice.state.description
        self.date = invoice.formattedPeriodOfIssue
        self.canDownloadFile = invoice.filename != nil
        self.canUploadFile = invoice.filename == nil
            && invoice.userWorkType != WorkType.agreement
            && (invoice.state == InvoiceState.notIssued || invoice.state == InvoiceState.waiting)
        if invoice.filename == nil {
            if invoice.userWorkType == WorkType.agreement {
                self.infoMessage = L10n.userWorkTypeIsAgreement
            }
            if (invoice.state == InvoiceState.approved) {
                self.infoMessage = L10n.invoiceIsAlreadyApproved
            }
            if (invoice.state == InvoiceState.paid) {
                self.infoMessage = L10n.invoiceIsAlreadyPaid
            }
        }
        self.value = ""
        if  let doubleValue = invoice.value,
            let value = Double(doubleValue)?.toCzechCrowns {
            self.value = value
        }
    }

}
