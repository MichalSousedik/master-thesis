//
//  HttpResponseHandlerTests.swift
//  MilacciTests
//
//  Created by Michal Sousedik on 02/01/2021.
//  Copyright © 2021 Michal Sousedik. All rights reserved.
//


import XCTest
import Alamofire
import RxCocoa
import RxSwift
import RxBlocking
@testable import Milacci

class HttpResponseHandlerTests: XCTestCase {
    
    func testHandle_200_fulfilled() throws {
        AuthServiceMock.signIn(role: "user")
        let expectation = XCTestExpectation(description: "SignInResponse returned")
        try AuthHttpRouter.authenticate(accessToken: "Access Token")
            .request(usingHttpService: AuthHttpService())
            .responseJSON{ result in
                HttpResponseHandler.handle(result: result, completion: { (item, error) in
                    if error != nil {
                        XCTFail("Error may not be present")
                    } else {
                        expectation.fulfill()
                    }
                }, type: SignInResponse.self)}
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHandle_badRequest_fulfilled() throws {
        let errorMessage = "Database unavailable"
        AuthServiceMock.signInError(statusCode: 400, message: errorMessage)
        let expectation = XCTestExpectation(description: "Error 400 returned")
        try AuthHttpRouter.authenticate(accessToken: "Access Token")
            .request(usingHttpService: AuthHttpService())
            .responseJSON{ result in
                HttpResponseHandler.handle(result: result, completion: { (item, error) in
                    if let error = error,
                       case NetworkingError.custom(message: errorMessage) = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Error may not be present")
                    }
                }, type: SignInResponse.self)}
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHandle_resourceNotFound_fulfilled() throws {
        AuthServiceMock.signInError(statusCode: 404, message: "")
        let expectation = XCTestExpectation(description: "Error 404 returned")
        try AuthHttpRouter.authenticate(accessToken: "Access Token")
            .request(usingHttpService: AuthHttpService())
            .responseJSON{ result in
                HttpResponseHandler.handle(result: result, completion: { (item, error) in
                    if let error = error,
                       case NetworkingError.resourceNotFound = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Error may not be present")
                    }
                }, type: SignInResponse.self)}
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHandle_decodingFailed_fulfilled() throws {
        AuthServiceMock.signInError(statusCode: 200, message: "")
        let expectation = XCTestExpectation(description: "Error Decoding Failed Returned")
        try AuthHttpRouter.authenticate(accessToken: "Access Token")
            .request(usingHttpService: AuthHttpService())
            .responseJSON{ result in
                HttpResponseHandler.handle(result: result, completion: { (item, error) in
                    if error != nil {
                        expectation.fulfill()
                    } else {
                        XCTFail("Error may not be present")
                    }
                }, type: UserDetail.self)}
        wait(for: [expectation], timeout: 2.0)
    }
    
}
