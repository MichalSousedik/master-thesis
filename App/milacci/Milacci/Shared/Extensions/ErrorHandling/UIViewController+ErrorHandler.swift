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
        handle(error, from: self, retryHandler: retryHandler)
    }
}
