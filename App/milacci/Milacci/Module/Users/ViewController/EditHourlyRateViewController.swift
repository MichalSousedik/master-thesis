//
//  EditHourlyWageViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 15/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift

class EditHourlyRateViewController: UIViewController, Storyboardable {

    @IBOutlet weak var validFromTextField: UITextField!
    @IBOutlet weak var newHourlyRate: UITextField!
    @IBOutlet weak var currentHourlyRateLabel: UILabel!

    private var viewModel: EditHourlyRateViewPresentable!
    var viewModelBuilder: EditHourlyRateViewPresentable.ViewModelBuilder!

    private var loadingViewController: LoadingViewController?

    private var saveButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemSymbol: .checkmark), style: .plain, target: nil, action: nil)
    var currentHourlyRate: Double?
    let datePicker = UIDatePicker()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = viewModelBuilder((
            saveTrigger: saveButton.rx.tap.map({[newHourlyRate, datePicker] _ in
                if let text = newHourlyRate?.text,
                   let value = Double(text) {
                    return (value: value, since: datePicker.date)
                }
                return (value: 0, since: datePicker.date)
            }).asDriver(onErrorDriveWith: .empty()),
            ()
        ))

        setupUI()
        setupViewModelBinding()

    }

}

extension EditHourlyRateViewController {

    func setupUI() {

        saveButton.tintColor = Asset.Colors.primary1.color
        self.navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false

        setupDatePicker()
        setupToolbarButtons()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tap)

        tap.rx.event.bind {[weak self] _ in
            self?.view.endEditing(true)
        }.disposed(by: bag)
        newHourlyRate.rx.text.asDriver().drive {[saveButton] (rate) in
            if let rate = rate,
               Double(rate) != nil {
                saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
            }
        }.disposed(by: bag)
        saveButton.rx.tap.asDriver().drive { [weak self] _ in
            self?.view.endEditing(true)
            self?.saveButton.isEnabled = false
        }.disposed(by: bag)

    }

    func setupViewModelBinding() {
        self.viewModel.output.currentHourlyRate.drive {[weak self] in
            self?.currentHourlyRateLabel?.text = "Current: \($0?.toCzechCrowns ?? "-")"
            self?.currentHourlyRate = $0
        }.disposed(by: bag)
        self.viewModel.output.since.drive {[validFromTextField, datePicker] (date) in
            validFromTextField?.text = EditHourlyRateViewController.format(date: date)
            datePicker.date = date
        }.disposed(by: bag)
        self.viewModel.output.errorOccured.drive{ [weak self] in
            self?.handle($0, retryHandler: nil)
        }.disposed(by: bag)
        self.viewModel.output.isLoading.drive{ [weak self] loading in
            if loading {
                let loadingViewController = LoadingViewController()
                self?.loadingViewController = loadingViewController
                self?.add(loadingViewController)
            } else {
                self?.loadingViewController?.remove()
                self?.loadingViewController = nil
                self?.saveButton.isEnabled = true
            }
        }.disposed(by: bag)

    }

    func setupToolbarButtons() {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        let plusTenPercent = UIBarButtonItem(title: "+ 10 %", style: .plain, target: self, action: nil)
        let plusTwentyPercent = UIBarButtonItem(title: "+ 20 %", style: .plain, target: self, action: nil)
        plusTenPercent.tintColor = Asset.Colors.primary1.color
        plusTwentyPercent.tintColor = Asset.Colors.primary1.color
        bar.items = [plusTenPercent, plusTwentyPercent]
        bar.sizeToFit()
        newHourlyRate.inputAccessoryView = bar
        plusTenPercent.rx.tap.bind {[weak self] _ in
            self?.newHourlyRate?.text = String(format: "%.f", (self?.currentHourlyRate ?? 0) * 1.1)
            self?.saveButton.isEnabled = true
        }.disposed(by: bag)
        plusTwentyPercent.rx.tap.bind {[weak self] _ in
            self?.newHourlyRate?.text = String(format: "%.f", (self?.currentHourlyRate ?? 0) * 1.2)
            self?.saveButton.isEnabled = true
        }.disposed(by: bag)
    }

    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        validFromTextField.inputView = datePicker
        datePicker.rx.controlEvent(.valueChanged).bind { [validFromTextField, datePicker] in
            validFromTextField?.text = EditHourlyRateViewController.format(date: datePicker.date)
        }.disposed(by: bag)

    }

    static func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd. MM. yyyy"
        return formatter.string(from: date)

    }
}
