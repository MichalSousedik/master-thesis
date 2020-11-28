//
//  HourlyWageViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 07/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class HourlyRateViewController: UIViewController, Storyboardable {

    @IBOutlet weak var hourlyRateLabel: UILabel!
    @IBOutlet weak var upcommingHourlyRateLabel: UILabel!

    private var viewModel: HourlyRateViewPresentable!
    var viewModelBuilder: HourlyRateViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()
    private let refresh = PublishRelay<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder(
            (
                refresh: refresh.asDriver(onErrorDriveWith: .empty()),
                ()
            )
        )
        self.setupUI()
        self.setupBinding()
        self.refresh.accept(())
    }

}

extension HourlyRateViewController {

    func setupUI() {
        hourlyRateLabel?.showAnimatedSkeleton()
        upcommingHourlyRateLabel?.isHidden = true
    }

    func setupBinding() {
        self.viewModel.output.error.drive { [weak self] (error) in
            self?.hourlyRateLabel?.hideSkeleton()
            self?.handle(error, retryHandler: { [weak self] in
                self?.hourlyRateLabel?.showSkeleton()
                self?.refresh.accept(())
            })
        }.disposed(by: bag)

        self.viewModel.output.hourlyRate.drive { [hourlyRateLabel] in
            hourlyRateLabel?.text = $0
            hourlyRateLabel?.hideSkeleton()
        }.disposed(by: bag)

        self.viewModel.output.upcommingRate.drive { [upcommingHourlyRateLabel] in
            upcommingHourlyRateLabel?.text = $0
            upcommingHourlyRateLabel?.isHidden = false
        }.disposed(by: bag)

    }
}
