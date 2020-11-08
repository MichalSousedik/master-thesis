//
//  ProfileViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserProfileViewController: UIViewController, Storyboardable {

    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dayOfBirthLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var signOutBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!

    private let refreshControl = UIRefreshControl()
    private var viewModel: UserProfileViewPresentable!
    var viewModelBuilder: UserProfileViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()
    private let refresh = PublishRelay<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder(
            (
                signOut: signOutBarButtonItem.rx.tap.asDriver(),
                refresh: refresh.asDriver(onErrorDriveWith: .empty())
            )
        )
        self.setupUI()
        self.setupBinding()
    }

    func setupUI() {
        self.scrollView.refreshControl = refreshControl
        self.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe({[weak self] _ in
                self?.refresh.accept(())
            }).disposed(by: bag)
        self.showSkeleton()
    }

    func showSkeleton(){
        self.degreeLabel.showAnimatedSkeleton()
        self.nameLabel.showAnimatedSkeleton()
        self.jobTitleLabel.showAnimatedSkeleton()
        self.dayOfBirthLabel.showAnimatedSkeleton()
        self.capacityLabel.showAnimatedSkeleton()
        self.phoneNumberLabel.showAnimatedSkeleton()
        self.emailLabel.showAnimatedSkeleton()
        self.workTypeLabel.showAnimatedSkeleton()
    }

    func setupBinding() {
        self.viewModel.output.degree.drive(onNext: { [degreeLabel] in
            degreeLabel?.text = $0
            degreeLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.name.drive(onNext: { [nameLabel] in
            nameLabel?.text = $0
            nameLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.jobTitle.drive(onNext: { [jobTitleLabel] in
            jobTitleLabel?.text = $0
            jobTitleLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.dayOfBirth.drive(onNext: { [dayOfBirthLabel] in
            dayOfBirthLabel?.text = $0
            dayOfBirthLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.hourlyCapacity.drive(onNext: { [capacityLabel] in
            capacityLabel?.text = $0
            capacityLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.phoneNumber.drive(onNext: { [phoneNumberLabel] in
            phoneNumberLabel?.text = $0
            phoneNumberLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.email.drive(onNext: { [emailLabel] in
            emailLabel?.text = $0
            emailLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.workType.drive(onNext: { [workTypeLabel] in
            workTypeLabel?.text = $0
            workTypeLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.error.drive(onNext: { [weak self] in
            self?.handle($0) { [weak self] in
                self?.refresh.accept(())
            }
        }).disposed(by: bag)
        self.viewModel.output.isLoading.drive(onNext: { [weak self] in
            if !$0 {
                self?.refreshControl.endRefreshing()
            }
        }).disposed(by: bag)

    }

}
