//
//  AuthService.swift
//  Milacci
//
//  Created by Michal Sousedik on 27/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import Alamofire

protocol AuthAPI {
    func signIn(accessToken: String) -> Single<SignInResponse>
    func refresh(refreshToken: String) -> Single<SignInResponse>
}

class AuthService: AuthAPI {

    static let shared: AuthAPI = AuthService()
    private lazy var httpService = AuthHttpService()

    func signIn(accessToken: String) -> Single<SignInResponse> {
        return Single.create{ [httpService] (single) -> Disposable in
            do {
                try AuthHttpRouter.authenticate(accessToken: accessToken)
                    .request(usingHttpService: httpService)
                    .responseJSON{ result in
                        HttpResponseHandler.handle(result: result, completion: { (item, error) in
                            if let error = error {
                                single(.error(error))
                            } else if let item = item {
                                single(.success(item))
                            }
                        }, type: SignInResponse.self)
                }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }

            return Disposables.create()
        }
    }

    func refresh(refreshToken: String) -> Single<SignInResponse> {
        return Single.create{ [httpService] (single) -> Disposable in
            do {
                try AuthHttpRouter.refreshToken(refreshToken: refreshToken)
                    .request(usingHttpService: httpService)
                    .responseJSON {
                        HttpResponseHandler.handle(result: $0, completion: { (item, error) in
                            if let error = error {
                                single(.error(error))
                            } else if let item = item {
                                single(.success(item))
                            }
                        }, type: SignInResponse.self)
                    }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }

            return Disposables.create()
        }
    }

}
