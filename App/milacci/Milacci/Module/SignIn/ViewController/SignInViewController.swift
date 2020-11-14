//
//  ViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 23/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import GoogleSignIn
import Alamofire
import RxSwift
import RxRelay

class SignInViewController: UIViewController, Storyboardable {

    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var signInWithAckeeButton: UIButton!
    @IBOutlet weak var signInWithGoogleButton: UIButton!
    let bag = DisposeBag()

    var passwordValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var usernameValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    @IBAction func signInWithAckee(_ sender: Any) {
        //        "https://milacci2-api-development.ack.ee/api/v1/auth/sign-in"
        do {
            var request = try URLRequest(url: "https://milacci2-api-development.ack.ee/api/v1/auth/sign-in".asURL(), method: .post, headers: ["Content-Type": "application/json"])
            request.httpBody = body()
            AF.request(request).responseJSON(completionHandler: { (result) in
                debugPrint(result)
            })}
        catch {
            print(error)
        }
    }

    func body() -> Data? {
        let auth: [String: String] = ["email": self.usernameLabel.text ?? "", "password": self.passwordLabel.text ?? ""]
        let jsonData = try? JSONSerialization.data(withJSONObject: auth)
        return jsonData
    }

    @IBAction func signInWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.combineLatest(passwordValid, usernameValid).bind {[signInWithAckeeButton] in
            signInWithAckeeButton?.isEnabled = $0 && $1
        }.disposed(by: bag)

        usernameLabel.addTarget(self, action: #selector(usernameLabelDidChange(_:)), for: .editingChanged)
        passwordLabel.addTarget(self, action: #selector(passwordLabelDidChange(_:)), for: .editingChanged)
        self.usernameLabel.keyboardType = UIKeyboardType.emailAddress
        signInWithAckeeButton.layer.cornerRadius = 5
        signInWithGoogleButton.layer.cornerRadius = 5
        signInWithGoogleButton.layer.borderWidth = 1
        signInWithGoogleButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        GIDSignIn.sharedInstance()?.presentingViewController = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func usernameLabelDidChange(_ textField: UITextField) {
        if validateEmailId(emailID: textField.text ?? "") {
            self.usernameValid.accept(true)
        } else {
            self.usernameValid.accept(false)
        }
    }

    @objc func passwordLabelDidChange(_ textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            self.passwordValid.accept(false)
        } else {
            self.passwordValid.accept(true)
        }

    }

    func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }

}

class AckeeButton: UIButton {

    override var isEnabled: Bool{
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

}
