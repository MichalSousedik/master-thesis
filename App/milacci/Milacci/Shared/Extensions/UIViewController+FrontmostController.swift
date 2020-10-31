//
//  UIViewController+FrontmostController.swift
//  Milacci
//
//  Created by Michal Sousedik on 26/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Goes through view controller hierarchy and returns view controller on top
    fileprivate var frontmostChild: UIViewController? {
        switch self {
        case let split as UISplitViewController: return split.viewControllers.last
        case let navigation as UINavigationController: return navigation.topViewController
        case let tabBar as UITabBarController: return tabBar.selectedViewController
        default: return nil
        }
    }

    var frontmostController: UIViewController {
        presentedViewController?.frontmostController ?? frontmostChild?.frontmostController ?? self
    }
}
