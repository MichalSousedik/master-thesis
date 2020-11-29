//
//  PersonalInfoFormValidator.swift
//  Milacci
//
//  Created by Michal Sousedik on 19/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PersonalInfoFormValidator {

    func validate(validators: [Observable<Bool>]) -> Observable<Bool> {
        Observable.combineLatest(validators).map{$0.allSatisfy { $0 }}
    }

    static func notEmpty(textField: UITextField) -> Observable<Bool> {
        textField.rx.text.map {
            if let text = $0,
               !text.isEmpty {
                return true
            }
            return false
        }
    }

}
