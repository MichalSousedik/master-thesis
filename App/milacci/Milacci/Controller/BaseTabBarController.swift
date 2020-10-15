//
//  BaseTabBarController.swift
//  Milacci
//
//  Created by Michal Sousedik on 31/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    let coordinators: [Coordinator] = [
        InvoicesCoordinator(navigationController: BaseNavigationController()),
        ProfileCoordinator(navigationController: BaseNavigationController())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "primary")
 
        setTabBarItemColors(appearance.stackedLayoutAppearance)
        setTabBarItemColors(appearance.inlineLayoutAppearance)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance)
        
        self.tabBar.standardAppearance = appearance
        
        self.tabBar.items?.forEach { tabBarItem in
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        }
        
        coordinators.forEach({$0.start()})
        viewControllers = coordinators.compactMap({$0.navigationController})
    }
    
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = UIColor(named: "secondary")
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "secondary")!]
        
        itemAppearance.selected.iconColor = .white
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

}
