//
//  BaseNavigationControllerViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 29/02/2020.
//

import UIKit

class BaseNavigationController: UINavigationController {

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(named: "Primary")
            self.navigationBar.standardAppearance = navBarAppearance
            self.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }

}
