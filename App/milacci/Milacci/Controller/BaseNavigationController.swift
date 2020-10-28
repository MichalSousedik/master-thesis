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
        navigationBarAppearence.shadowColor = .clear
        navigationBarAppearence.backgroundColor = UIColor(named: "primary")
        navigationBarAppearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationBarAppearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
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
