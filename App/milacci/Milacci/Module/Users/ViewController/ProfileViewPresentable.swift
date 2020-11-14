//
//  ProfileViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 14/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    var viewModel: UserProfileViewPresentable!
    var viewModelBuilder: UserProfileViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()
    let refresh = PublishRelay<Void>()

    var userProfileHeaderViewController: UserProfileHeaderViewController!
    var userProfileDetailViewController: UserProfileDetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder(provideViewPresentableInput())
        self.setupUI()
        self.setupBinding()
    }

    func provideViewPresentableInput() -> UserProfileViewPresentable.Input {
        fatalError("Not implemented")
    }

    func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        self.setupUserProfileHeaderViewController()
        self.setupUserProfileDetailViewController()
    }

    func setupBinding() {
        self.viewModel.output.error.drive(onNext: { [weak self] in
            self?.handle($0) { [weak self] in
                self?.refresh.accept(())
            }
        }).disposed(by: bag)
    }

    func setupUserProfileHeaderViewController() {
        userProfileHeaderViewController.viewModel = self.viewModel
        add(userProfileHeaderViewController)
        userProfileHeaderViewController.view.translatesAutoresizingMaskIntoConstraints = false
        userProfileHeaderViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        userProfileHeaderViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        userProfileHeaderViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }

    func setupUserProfileDetailViewController() {
        userProfileDetailViewController.viewModel = self.viewModel
        userProfileDetailViewController.refresh = self.refresh
        add(userProfileDetailViewController)
        userProfileDetailViewController.view.translatesAutoresizingMaskIntoConstraints = false
        userProfileDetailViewController.view.topAnchor.constraint(equalTo: userProfileHeaderViewController.view.bottomAnchor, constant: 10).isActive = true
        userProfileDetailViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        userProfileDetailViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        userProfileDetailViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
