//
//  ViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 23/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, Storyboardable {

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

}

