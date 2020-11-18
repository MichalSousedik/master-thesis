//
//  EditUserProfileViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 15/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift

class EditUserProfileViewController: UIViewController, Storyboardable {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var hourlyCapacityTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var workTypeTextField: UITextField!
    @IBOutlet weak var userDeleteButton: UIButton!

    let jobTitles = JobTitle.allCases
    var jobTitlePickedIndex: Int?
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupJobTitleTextField()
    }

    func setupJobTitleTextField() {
        let imageView = UIImageView(image: UIImage(systemSymbol: .chevronRight))
        imageView.tintColor = UIColor.secondaryLabel
        let rightView = UIView(frame: CGRect(
                                x: 0, y: 0,
                                width: imageView.frame.width + 15,
                                height: imageView.frame.height))
        rightView.addSubview(imageView)
        jobTitleTextField.rightView = rightView
        jobTitleTextField.rightViewMode = .always

        let jobTitlePicker = UIPickerView()
        jobTitleTextField.inputView = jobTitlePicker

        jobTitlePicker.delegate = self
    }
}

extension EditUserProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return jobTitles.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return jobTitles[row].description
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        jobTitlePickedIndex = row
        jobTitleTextField.text = jobTitles[row].description
    }

}
