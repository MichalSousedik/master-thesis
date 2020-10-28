//
//  FileAction.swift
//  Milacci
//
//  Created by Michal Sousedik on 15/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire

protocol FileAction {
    func image() -> UIImage?
    func execute()
}

struct FileActionFactory{

    static func create(fileName: String?, vcDelegate: InvoiceDetailViewController) -> FileAction {
        if fileName == nil {
            return UploadFile(vcDelegate: vcDelegate)
        } else {
            return DownloadFile(vcDelegate: vcDelegate)
        }
    }

}

struct UploadFile: FileAction {

    weak var vcDelegate: InvoiceDetailViewController?

    func image() -> UIImage? {
        return UIImage(systemName: "plus")
    }

    func execute() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeZipArchive)], in: .open)
        guard let vcDelegate = vcDelegate else { fatalError("VC Delegate is not present") }
        documentPicker.delegate = vcDelegate
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
        vcDelegate.present(documentPicker, animated: true)
    }

}

struct DownloadFile: FileAction {

    weak var vcDelegate: InvoiceDetailViewController?

    func image() -> UIImage? {
        return UIImage(systemName: "icloud.and.arrow.down")
    }

    func execute() {
        vcDelegate?.invoiceButton.isEnabled = false
        vcDelegate?.invoiceProgressView.isHidden = false
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        AF.download("https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-large-zip-file.zip", to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
                print(response)
                vcDelegate?.invoiceButton.isEnabled = true
                vcDelegate?.invoiceProgressView.isHidden = true
            }
    }

}
