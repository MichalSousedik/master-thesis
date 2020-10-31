//
//  AppDelegateErrorHandler.swift
//  Milacci
//
//  Created by Michal Sousedik on 25/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

extension AppDelegate {
    override func handle(_ error: Error,
                         from viewController: UIViewController,
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
                    guard let retryHandler = retryHandler else {return}
                    retryHandler() }
            ))
            break
        case .nonRetryable:
            break
        case .requiresLogout:
//            return performLogout()
        fatalError("Not implemented")
        }

        viewController.present(alert, animated: true)
    }
}
