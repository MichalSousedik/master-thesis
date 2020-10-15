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
    var filename: Bool { get }
    var value: String { get }
    var invoice: Invoice { get }
}

struct InvoiceViewModel : InvoiceViewPresentable{
    var date: String
    var state: String
    var filename: Bool
    var value: String
    var invoice: Invoice
}

extension InvoiceViewModel {
    
    init(withInvoice invoice: Invoice){
        self.invoice = invoice
        self.state = invoice.state.description
        self.date = invoice.date
        self.filename = invoice.filename != nil
        self.value = invoice.value.toCzechCrowns
    }
    
}
