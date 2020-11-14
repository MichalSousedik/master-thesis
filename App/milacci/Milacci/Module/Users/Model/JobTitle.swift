//
//  JobTitle.swift
//  Milacci
//
//  Created by Michal Sousedik on 08/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

enum JobTitle: String, Codable {
    case backend = "backend"
    case frontend = "frontend"
    case android = "android"
    case ios = "ios"
    case projectManager = "projectManager"
    case devops = "devops"
    case tester = "tester"
    case design = "design"
    case marketing = "marketing"
    case hr = "hr"
    case office = "office"
    case sales = "sales"
    case accounts = "accounts"
    case boss = "boss"
}

extension JobTitle {

    var description: String {
        switch self{
        case .backend: return L10n.backend
        case .frontend: return L10n.frontend
        case .android: return L10n.android
        case .ios: return L10n.ios
        case .projectManager: return L10n.projectManager
        case .devops: return L10n.devops
        case .tester: return L10n.tester
        case .design: return L10n.design
        case .marketing: return L10n.marketing
        case .hr: return L10n.hr
        case .office: return L10n.office
        case .sales: return L10n.sales
        case .accounts: return L10n.accounts
        case .boss: return L10n.boss
        }
    }

}
