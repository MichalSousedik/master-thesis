//
//  TimeEntry.swift
//  Milacci
//
//  Created by Michal Sousedik on 31/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation


class TimeEntry {
    
    var dayOfMonth: String
    var month: String
    var timeEntryTitle: String
    var timeEntryDetail: String
    var hours: String
    
    init(dayOfMonth: String, month: String, timeEntryTitle: String, timeEntryDetail: String, hours: String){
        self.dayOfMonth = dayOfMonth
        self.month = month
        self.timeEntryTitle = timeEntryTitle
        self.timeEntryDetail = timeEntryDetail
        self.hours = hours
    }
    
}
