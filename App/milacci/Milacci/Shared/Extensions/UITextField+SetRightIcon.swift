//
//  UITextField+SetRightIcon.swift
//  Milacci
//
//  Created by Michal Sousedik on 24/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import UIKit

extension UITextField {

    func setRightIcon(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.label
        let rightView = UIView(frame: CGRect(
                                x: 10, y: 0,
                                width: imageView.frame.width + 15,
                                height: imageView.frame.height))
        rightView.addSubview(imageView)
        self.rightView = rightView
        self.rightViewMode = .always
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        rightView.isUserInteractionEnabled = true
        rightView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.becomeFirstResponder()

        // Your action
    }

}
