    //
//  AppCoordinator.swift
//  Milacci
//
//  Created by Michal Sousedik on 22/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import UIKit
//import GoogleSignIn

    
class AppCoordinator: BaseCoordinator {
 
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        reload()
    }
    
    func reload() {
//        if(GIDSignIn.sharedInstance()?.currentUser == nil){
//            let signInCoordinator = SignInCoordinator()
//            self.add(coordinator: signInCoordinator)
//            signInCoordinator.start()
//            window.rootViewController = signInCoordinator.navigationController
//        } else {
            window.rootViewController = BaseTabBarController()
//        }
        window.makeKeyAndVisible()
    }
    

}
