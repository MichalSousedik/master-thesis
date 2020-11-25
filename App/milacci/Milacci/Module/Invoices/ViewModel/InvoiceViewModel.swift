//
//  InvoiceCellViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 09/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxDataSources

typealias InvoiceItemsSection = AnimatableSectionModel<Int, InvoiceViewModel>

protocol InvoiceViewPresentable: IdentifiableType, Equatable {
    var title: String { get }
    var state: String { get }
    var canDownloadFile: Bool { get }
    var canUploadFile: Bool { get }
    var value: String { get }
    var invoice: Invoice { get }
    var infoMessage: String? { get }
}

class InvoiceViewModel: InvoiceViewPresentable{

    static func == (lhs: InvoiceViewModel, rhs: InvoiceViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.state == rhs.state && lhs.invoice.id == rhs.invoice.id && lhs.value == rhs.value && lhs.infoMessage == rhs.infoMessage && lhs.canUploadFile == rhs.canUploadFile && lhs.canDownloadFile == rhs.canDownloadFile
    }

    typealias Identity = Int

    var title: String
    var state: String
    var value: String
    var invoice: Invoice
    var canDownloadFile: Bool
    var canUploadFile: Bool
    var infoMessage: String?

    init(withInvoice invoice: Invoice){
        self.invoice = invoice
        self.title = ""
        self.state = invoice.state.description
        self.canDownloadFile = invoice.filename != nil && invoice.filename != ""
        self.canUploadFile = false
        if invoice.filename == nil || invoice.filename == "" {
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

    var identity: Int {
        return invoice.id
    }
}

class EmployeeInvoiceViewModel: InvoiceViewModel {

    override init(withInvoice invoice: Invoice){
        super.init(withInvoice: invoice)
        var title = "-"
        if let user = invoice.user {
            title = "\(user.name ?? "-") \(user.surname ?? "-")"
        }
        self.title = title
    }

}

class MyInvoiceViewModel: InvoiceViewModel {

    override init(withInvoice invoice: Invoice){
        super.init(withInvoice: invoice)
        self.title = invoice.formattedPeriodOfIssue
        self.canUploadFile = (invoice.filename == nil || invoice.filename == "")
            && invoice.userWorkType != WorkType.agreement
            && (invoice.state == InvoiceState.notIssued || invoice.state == InvoiceState.waiting)
    }

}
