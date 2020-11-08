//
//  WageTestViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 07/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class WageViewController: UIViewController, Storyboardable {

    var hourlyRateViewController: HourlyRateViewController!
    var wageChartViewController: WageChartViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

}

extension WageViewController {

    func setupUI() {
        self.setupHourlyRateViewController()
        self.setupChartViewController()
    }

    func setupHourlyRateViewController() {
        add(hourlyRateViewController)
            hourlyRateViewController.view.translatesAutoresizingMaskIntoConstraints = false
            hourlyRateViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            hourlyRateViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            hourlyRateViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true

    }

    func setupChartViewController() {
        add(wageChartViewController)
        wageChartViewController.view.translatesAutoresizingMaskIntoConstraints = false
    wageChartViewController.view.topAnchor.constraint(equalTo: hourlyRateViewController.view.bottomAnchor, constant: 5).isActive = true
        wageChartViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        wageChartViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        wageChartViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

    }

}
