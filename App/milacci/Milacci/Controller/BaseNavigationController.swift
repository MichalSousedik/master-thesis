//
//  BaseNavigationControllerViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 29/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.backgroundColor = Asset.Colors.primary.color
        navigationBarAppearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Asset.Colors.primary1.color]
        navigationBarAppearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Asset.Colors.primary1.color]
        self.navigationBar.standardAppearance = navigationBarAppearence

        self.navigationBar.tintColor = .white
        self.navigationBar.barStyle = .black

        // when the navigation bar has a neighbouring scroll view item (eg: scroll view, table view etc)
        // the "scrollEdgeAppearance" will be used
        // by default, scrollEdgeAppearance will have a transparent background
        self.navigationBar.scrollEdgeAppearance = navigationBarAppearence
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}
