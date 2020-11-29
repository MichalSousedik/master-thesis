//
//  EditUserProfileViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 15/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class EditPersonalInfoViewController: BaseViewController, Storyboardable {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var hourlyCapacityTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var workTypeTextField: UITextField!
    @IBOutlet weak var userDeleteButton: UIButton!

    private var viewModel: EditPersonalInfoViewPresentable!
    var viewModelBuilder: EditPersonalInfoViewPresentable.ViewModelBuilder!

    private var saveButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemSymbol: .checkmark), style: .plain, target: nil, action: nil)

    let jobTitles = JobTitle.allCases
    var jobTitlePickedIndex: Int?
    var jobTitlePicker: UIPickerView?
    let workTypes = WorkType.allCases
    var workTypePickedIndex: Int?
    var workTypePicker: UIPickerView?
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            saveTrigger: saveButton.rx.tap.map({[createSaveUserDetail] _ in
                return createSaveUserDetail()
            }).asDriver(onErrorDriveWith: .empty()),
            ()
        ))
        setupUI()
        setupViewModelBinding()
    }

}

extension EditPersonalInfoViewController {

    func setupUI() {
        saveButton.tintColor = Asset.Colors.primary1.color
        self.navigationItem.rightBarButtonItem = saveButton

        setupJobTitleTextField()
        setupWorkTypeTextField()
        setupValidators()
    }

    func setupWorkTypeTextField() {
        let imageView = UIImageView(image: UIImage(systemSymbol: .chevronRight))
        imageView.tintColor = UIColor.secondaryLabel
        let rightView = UIView(frame: CGRect(
                                x: 0, y: 0,
                                width: imageView.frame.width + 15,
                                height: imageView.frame.height))
        rightView.addSubview(imageView)
        workTypeTextField.rightView = rightView
        workTypeTextField.rightViewMode = .always

        self.workTypePicker = UIPickerView()
        self.workTypeTextField.inputView = workTypePicker

        self.workTypePicker?.delegate = self
        self.workTypePicker?.tag = 2
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

        self.jobTitlePicker = UIPickerView()
        self.jobTitleTextField.inputView = jobTitlePicker

        self.jobTitlePicker?.delegate = self
        self.jobTitlePicker?.tag = 1
    }

    func setupValidators() {

        PersonalInfoFormValidator().validate(validators: [
            PersonalInfoFormValidator.notEmpty(textField: firstnameTextField),
            PersonalInfoFormValidator.notEmpty(textField: lastnameTextField),
            self.viewModel.output.isLoading.map{!$0}.asObservable()
        ])
        .bind(to: saveButton.rx.isEnabled).disposed(by: bag)

    }

    func setupViewModelBinding() {
        self.viewModel.output.name.drive { [weak self] in
            self?.firstnameTextField?.text = $0
        }.disposed(by: bag)
        self.viewModel.output.surname.drive { [lastnameTextField] in
            lastnameTextField?.text = $0
        }.disposed(by: bag)
        self.viewModel.output.jobTitle.drive { [weak self] in
            self?.jobTitleTextField?.text = $0?.description
            if let jobTitle = $0,
               let index = self?.jobTitles.firstIndex(of: jobTitle){
                self?.jobTitlePicker?.selectRow(index, inComponent: 0, animated: true)
                self?.jobTitlePickedIndex = index
            }
        }.disposed(by: bag)
        self.viewModel.output.degree.drive { [degreeTextField] in
            degreeTextField?.text = $0
        }.disposed(by: bag)
        self.viewModel.output.hourlyCapacity.drive { [hourlyCapacityTextField] in
            hourlyCapacityTextField?.text = $0
        }.disposed(by: bag)
        self.viewModel.output.contactEmail.drive { [emailTextField] in
            emailTextField?.text = $0
        }.disposed(by: bag)
        self.viewModel.output.phoneNumber.drive { [phoneNumberTextField] in
            phoneNumberTextField?.text = $0
        }.disposed(by: bag)
        self.viewModel.output.workType.drive { [weak self] in
            self?.workTypeTextField?.text = $0?.description
            if let workType = $0,
               let index = self?.workTypes.firstIndex(of: workType){
                self?.workTypePicker?.selectRow(index, inComponent: 0, animated: true)
                self?.workTypePickedIndex = index
            }
        }.disposed(by: bag)
        self.viewModel.output.error.drive{ [weak self] in
            self?.handle($0, retryHandler: nil)
        }.disposed(by: bag)
        self.viewModel.output.isLoading.drive{ [weak self] loading in
            if loading {
                self?.startModalLoader()
            } else {
                self?.stopModalLoader()
                self?.saveButton.isEnabled = true
            }
        }.disposed(by: bag)

    }
}

extension EditPersonalInfoViewController {

    func createSaveUserDetail() -> EditPersonalInfoViewPresentable.SaveUserDetail {
        return (name: self.firstnameTextField.text, surname: self.lastnameTextField.text, jobTitle: pickedJobTitle(), degree: self.degreeTextField.text, hourlyCapacity: hourlyCapacityTextField.text, phoneNumber: phoneNumberTextField.text, contactEmail: emailTextField.text, workType: pickedWorkType())
    }

    func pickedJobTitle() -> JobTitle? {
        if let index = self.jobTitlePickedIndex {
            return self.jobTitles[index]
        }
        return nil
    }

    func pickedWorkType() -> WorkType? {
        if let index = self.workTypePickedIndex {
            return self.workTypes[index]
        }
        return nil
    }

}

extension EditPersonalInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return jobTitles.count
        } else {
            return workTypes.count
        }
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return jobTitles[row].description
        } else {
            return workTypes[row].description
        }
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            jobTitlePickedIndex = row
            jobTitleTextField.text = jobTitles[row].description
        } else {
            workTypePickedIndex = row
            workTypeTextField.text = workTypes[row].description
        }
    }

}
