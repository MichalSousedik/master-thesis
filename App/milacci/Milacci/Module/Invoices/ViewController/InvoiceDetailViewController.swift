//
//  MyInvoiceDetailViewController.swift
//  Milacci
//
//  Created by Michal Sousedik on 26/05/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SkeletonView

class InvoiceDetailViewController: UIViewController, Storyboardable {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var hoursTitleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var hourlyWageTitleLabel: UILabel!
    @IBOutlet weak var hourlyWageLabel: UILabel!
    @IBOutlet weak var invoiceButton: UIButton!
    @IBOutlet weak var invoiceProgressView: UIProgressView!

    private var viewModel: InvoiceDetailViewPresentable!
    var viewModelBuilder: InvoiceDetailViewPresentable.ViewModelBuilder!
    private let bag = DisposeBag()

    private var fileAction: FileAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder(())
        self.setupUI()
        self.setupBinding()
    }

    @IBAction func press(_ sender: Any) {
        fileAction?.execute()
    }

}

private extension InvoiceDetailViewController {

    func setupUI() {
        hourlyWageLabel.showAnimatedGradientSkeleton()
        hourlyWageTitleLabel.showAnimatedGradientSkeleton()
        hoursLabel.showAnimatedGradientSkeleton()
        hoursTitleLabel.showAnimatedGradientSkeleton()

    }

    func setupBinding() {
        self.viewModel.output.date.drive(self.rx.title)
            .disposed(by: bag)
        self.viewModel.output.value.drive(valueLabel.rx.text).disposed(by: bag)
        self.viewModel.output.state.drive(stateLabel.rx.text).disposed(by: bag)
        self.viewModel.output.hours.drive(onNext: { [hoursLabel, hoursTitleLabel] in
            hoursLabel?.text = $0
            hoursLabel?.hideSkeleton()
            hoursTitleLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.hourlyWage.drive(onNext: { [hourlyWageLabel, hourlyWageTitleLabel] in
            hourlyWageLabel?.text = $0
            hourlyWageLabel?.hideSkeleton()
            hourlyWageTitleLabel?.hideSkeleton()
        }).disposed(by: bag)
        self.viewModel.output.fileName.drive(onNext: { [invoiceButton, self] (fileName) in
            guard let invoiceButton = invoiceButton else { print("invoice button does not exist"); return}
            self.fileAction = FileActionFactory.create(fileName: fileName, vcDelegate: self)
            invoiceButton.layer.cornerRadius = 0.5 * invoiceButton.bounds.size.width
            invoiceButton.setImage(fileAction?.image(), for: .normal)
        }).disposed(by: bag)
    }

}

extension InvoiceDetailViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            print("First URL does not exist")
            return
        }
//        AF.upload(url, to: "https://milacci2-api-development.ack.ee/api/v1/invoices/1/file-urls")
        AF.upload(url, to: "https://httpbin.org/post")
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")

                self.invoiceProgressView.progress = Float(progress.fractionCompleted)
            }
            .responseJSON(completionHandler: { response in
                print(response)
                self.invoiceButton.isEnabled = true
                self.invoiceProgressView.isHidden = true
                self.viewModel.refreshState()
        })

    }
}

