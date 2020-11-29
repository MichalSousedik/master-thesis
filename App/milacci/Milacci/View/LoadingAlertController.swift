//
//  LoadingAlertView.swift
//  Milacci
//
//  Created by Michal Sousedik on 29/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class LoadingAlertController: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
    }

}
