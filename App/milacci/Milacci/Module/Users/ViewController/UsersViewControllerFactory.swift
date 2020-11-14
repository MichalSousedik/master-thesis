//
//  UsersViewControllerFactory.swift
//  Milacci
//
//  Created by Michal Sousedik on 14/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import RxSwift

class UsersViewControllerFactory {

    static func create(viewModelBuilder: @escaping UsersViewPresentable.ViewModelBuilder, title: String, searchFieldText: String ) -> UsersViewController {
        let viewController = UsersViewController.instantiate()
        viewController.viewModelBuilder = viewModelBuilder
        viewController.titleText = title
        viewController.searchFieldText = searchFieldText
        viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemSymbol: .person3Fill), tag: 0)
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
        return viewController
    }

}
