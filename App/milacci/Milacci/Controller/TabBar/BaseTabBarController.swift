//
//  BaseTabBarController.swift
//  Milacci
//
//  Created by Michal Sousedik on 31/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    var coordinators: [Coordinator] {[]}

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarAppearance()
        appearance.backgroundColor = Asset.Colors.primary.color

        setTabBarItemColors(appearance.stackedLayoutAppearance)
        setTabBarItemColors(appearance.inlineLayoutAppearance)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance)

        self.tabBar.standardAppearance = appearance

        let coordinators = self.coordinators
        coordinators.forEach({$0.start()})
        viewControllers = coordinators.compactMap({$0.navigationController})
    }

    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = Asset.Colors.secondary.color
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Asset.Colors.secondary.color]

        itemAppearance.selected.iconColor = Asset.Colors.primary1.color
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Asset.Colors.primary1.color]
    }

}
