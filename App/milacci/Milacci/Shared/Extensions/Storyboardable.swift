//
//  Storyboardable.swift
//  Milacci
//
//  Created by Michal Sousedik on 21/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

import UIKit

protocol Storyboardable {
    static func instantiate() -> Self
}

//https://www.hackingwithswift.com/articles/71/how-to-use-coordinator-pattern-in-ios-app
extension Storyboardable where Self: UIViewController {

    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: className)
    }

}
