//
//  UserHourRateViewModel.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxDataSources

struct HourRateStat: Codable {
    let percentageIncrease: Double
}

typealias UserHourRateItemsSection = AnimatableSectionModel<String, UserHourRateViewModel>

protocol UserHourRateViewPresentable: IdentifiableType, Equatable {
    var firstname: String { get }
    var lastname: String { get }
    var lastHourlyRate: String { get }
    var newHourlyRate: String { get }
    var percentageIncrease: String { get }
}

struct UserHourRateViewModel: UserHourRateViewPresentable {
    static func == (lhs: UserHourRateViewModel, rhs: UserHourRateViewModel) -> Bool {
        return lhs.firstname == rhs.firstname && lhs.lastname == rhs.lastname && lhs.id == rhs.id && lhs.percentageIncrease == rhs.percentageIncrease && lhs.lastHourlyRate == rhs.lastHourlyRate && lhs.newHourlyRate == rhs.newHourlyRate
    }

    typealias Identity = Int

    var id: Int
    var firstname: String
    var lastname: String
    var lastHourlyRate: String
    var newHourlyRate: String
    var percentageIncrease: String

    var identity: Int {
        return id
    }

}

extension UserHourRateViewModel {

    init(withModel model: UserDetail){
        self.id = model.id
        self.firstname = model.name ?? "-"
        self.lastname = model.surname ?? "-"
        self.lastHourlyRate = "-"
        self.newHourlyRate = "-"
        self.percentageIncrease = "- %"
        if let hourRates = model.hourRates,
           hourRates.count >= 2 {
            self.lastHourlyRate = hourRates[1].value.toCzechCrowns
            self.newHourlyRate = hourRates[0].value.toCzechCrowns
            self.percentageIncrease = "\( String(format: "%.1f", hourRates[0].percentageIncrease ?? 0)) %"
        }
    }

}
