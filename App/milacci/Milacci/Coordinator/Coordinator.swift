//
//  Coordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 21/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
    
}

extension Coordinator {
    
    func add(coordinator: Coordinator) -> Void {
        self.childCoordinator.append(coordinator)
    }
    
    func remove(coordinator: Coordinator) {
        childCoordinator = childCoordinator.filter({
            $0 !== coordinator
        })
    }
    
}
