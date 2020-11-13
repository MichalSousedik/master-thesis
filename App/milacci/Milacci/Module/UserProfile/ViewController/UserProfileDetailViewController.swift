//
//  UserProfileDetailViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 13/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

class UserProfileDetailViewController: UIViewController, Storyboardable {

    @IBOutlet weak var hourlyRateStackView: UIStackView!
    @IBOutlet weak var hourlyRateLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var dayOfBirthLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var signOutBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!

    private let refreshControl = UIRefreshControl()
    var viewModel: UserProfileViewPresentable!
    private let bag = DisposeBag()
    var refresh: PublishRelay<Void>!
    var modifyController: ((UserProfileDetailViewController) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let modifyController = modifyController {
            modifyController(self)
        }
        setupUI()
        setupBinding()
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
        self.hourlyRateLabel.showAnimatedSkeleton()
        self.degreeLabel.showAnimatedSkeleton()
        self.dayOfBirthLabel.showAnimatedSkeleton()
        self.capacityLabel.showAnimatedSkeleton()
        self.phoneNumberLabel.showAnimatedSkeleton()
        self.emailLabel.showAnimatedSkeleton()
        self.workTypeLabel.showAnimatedSkeleton()
    }

    func setupBinding() {
        self.viewModel.output.hourlyRate.drive(onNext: { [hourlyRateLabel] in
            hourlyRateLabel?.text = $0
            hourlyRateLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.degree.drive(onNext: { [degreeLabel] in
            degreeLabel?.text = $0
            degreeLabel?.hideSkeleton()
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
