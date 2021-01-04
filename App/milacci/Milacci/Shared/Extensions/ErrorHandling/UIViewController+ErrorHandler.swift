//
//  UIViewControllerErroHandler.swift
//  Milacci
//
//  Created by Michal Sousedik on 25/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

extension UIViewController {
    func handle(_ error: Error,
                retryHandler: (() -> Void)?) {
        let alert = UIAlertController(
            title: L10n.errorOccured,
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(
            title: L10n.cancel,
            style: .default
        ))

        switch error.resolveCategory() {
        case .retryable:
            alert.addAction(UIAlertAction(
                title: L10n.retry,
                style: .default,
                handler: { _ in
                    if let retryHandler = retryHandler {
                        retryHandler()
                    }
            }))
            break
        case .nonRetryable:
            break
        }

        present(alert, animated: true)
    }
}
