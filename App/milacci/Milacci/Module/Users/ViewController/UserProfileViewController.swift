//
//  ProfileViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class UserProfileViewController: ProfileViewController {

    private var signOutButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemSymbol: .escape), style: .plain, target: nil, action: nil)

    override func setupUI() {
        super.setupUI()
        signOutButton.tintColor = Asset.Colors.primary1.color
        self.navigationItem.rightBarButtonItem = signOutButton
    }

    override func provideViewPresentableInput() -> UserProfileViewPresentable.Input {
        return (
            signOut: signOutButton.rx.tap.asDriver(),
            refresh: refresh.asDriver(onErrorDriveWith: .empty())
        )
    }

}
