//
//  UserProfileHeaderViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 12/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserProfileHeaderViewController: UIViewController, Storyboardable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!

    var viewModel: UserProfileViewPresentable!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBinding()
    }

    func setupUI() {
        self.showSkeleton()
    }

    func showSkeleton(){
        self.jobTitleLabel.showAnimatedSkeleton()
        self.nameLabel.showAnimatedSkeleton()
    }

    func setupBinding() {
        self.viewModel.output.name.drive(onNext: { [nameLabel] in
            nameLabel?.text = $0
            nameLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.jobTitle.drive(onNext: { [jobTitleLabel] in
            jobTitleLabel?.text = $0
            jobTitleLabel?.hideSkeleton()
        }).disposed(by: bag)

    }

}
