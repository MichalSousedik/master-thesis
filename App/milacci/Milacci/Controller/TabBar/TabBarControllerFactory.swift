//
//  TabBarControllerFactory.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

struct TabBarControllerFactory {
    static func create(roles: [Role]) -> BaseTabBarController {
        if roles.contains(.admin) {return AdminTabBarControoler()}
        if roles.contains(.teamLeader) {return TeamLeaderTabBarController()}
        if roles.contains(.user) {return WorkerTabBarControoler()}
        fatalError("Role is not supported")
    }

    private init(){}
}
