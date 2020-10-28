//
//  UIResponder.swift
//  Milacci
//
//  Created by Michal Sousedik on 25/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

extension UIResponder {

    @objc func handle(_ error: Error,
                      from viewController: UIViewController,
                      retryHandler: (() -> Void)?) {
        // This assertion will help us identify errors that were
        // either emitted by a view controller *before* it was
        // added to the responder chain, or never handled at all:
        guard let nextResponder = next else {
            return assertionFailure("""
            Unhandled error \(error) from \(viewController)
            """)
        }

        nextResponder.handle(error,
            from: viewController,
            retryHandler: retryHandler
        )

    }

}
