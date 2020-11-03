//
//  LoadingViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 25/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .label
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // We use a 0.25 second delay to not show an activity indicator
        // in case our data loads very quickly.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
}