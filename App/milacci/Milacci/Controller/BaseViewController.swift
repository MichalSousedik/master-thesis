//
//  BaseViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 29/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private var loadingAlert: UIAlertController?

    func startModalLoader() {
        let alert = LoadingAlertController(title: nil, message: "\(L10n.pleaseWait)...", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        self.loadingAlert = alert
    }

    func stopModalLoader() {
        if let alert = self.loadingAlert {
            alert.dismiss(animated: true, completion: nil)
        }
    }

}
