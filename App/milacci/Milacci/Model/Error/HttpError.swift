//
//  CustomError.swift
//  Milacci
//
//  Created by Michal Sousedik on 23/09/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

enum NetworkingError: Error {
    case unauthorized;
    case custom(message: String);
}
