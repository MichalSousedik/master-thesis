//
//  String+monthName.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

extension String {

    var month: String {
        switch(self){
        case "01" : return L10n.january
        case "02" : return L10n.february
        case "03" : return L10n.march
        case "04" : return L10n.april
        case "05" : return L10n.may
        case "06" : return L10n.june
        case "07" : return L10n.july
        case "08" : return L10n.august
        case "09" : return L10n.september
        case "10" : return L10n.october
        case "11" : return L10n.november
        case "12" : return L10n.december
        default: return L10n.unknownMonth
        }
    }
}
