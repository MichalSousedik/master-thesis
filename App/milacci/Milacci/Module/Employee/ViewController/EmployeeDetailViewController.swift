//
//  EmployeeDetailViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 12/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmployeeDetailViewController: UIViewController, Storyboardable {

    private var viewModel: UserProfileViewPresentable!
    var viewModelBuilder: UserProfileViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()
    private let refresh = PublishRelay<Void>()
//    var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Osobní údaje", "Mzda"])

    var userProfileHeaderViewController: UserProfileHeaderViewController!
    var userProfileDetailViewController: UserProfileDetailViewController!
//    var wageViewController: WageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder(
            (
                signOut: .empty(),
                refresh: refresh.asDriver(onErrorDriveWith: .empty())
            )
        )
        self.setupUI()
        self.setupBinding()
    }

    func setupUI() {
        self.navigationItem.largeTitleDisplayMode = .never

        self.setupUserProfileHeaderViewController()

        userProfileDetailViewController.viewModel = self.viewModel
        userProfileDetailViewController.refresh = self.refresh
        self.setupUserProfileDetailViewController()

//        segmentedControl.selectedSegmentIndex = 0
//
//        self.view.addSubview(segmentedControl)
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        segmentedControl.topAnchor.constraint(equalTo: userProfileHeaderViewController.view.bottomAnchor, constant: 10).isActive = true
//        segmentedControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
//        segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)

    }

//    @objc func indexChanged(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex{
//        case 0:
//            self.setupUserProfileDetailViewController()
//        case 1:
//            self.setupWageViewController()
//        default:
//            break
//        }
//    }

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
        add(userProfileDetailViewController)
        userProfileDetailViewController.view.translatesAutoresizingMaskIntoConstraints = false
        userProfileDetailViewController.view.topAnchor.constraint(equalTo: userProfileHeaderViewController.view.bottomAnchor, constant: 5).isActive = true
        userProfileDetailViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        userProfileDetailViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        userProfileDetailViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

    }
//
//    func setupWageViewController() {
//        add(wageViewController)
//        wageViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        wageViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5).isActive = true
//        wageViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        wageViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        wageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//
//    }

}
