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
                        do {
                            let user = try AuthService.parse(result: result)

                            print(user.credentials.accessToken)
                            single(.success(user))
                        } catch {
                            single(.error(error))
                        }
                }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }

            return Disposables.create()
        }
    }

}

extension AuthService {

    static func parse(result: AFDataResponse<Any>) throws -> SignInResponse {
        guard
            let data = result.data else {
            throw NetworkingError.custom(message: L10n.dataCouldnTBeExtractedFromResult)
        }

        return try perform(JSONDecoder().decode(SignInResponse.self, from: data))
            {NetworkingError.decodingFailed($0)}
    }
}

extension AuthService {
    static func perform<T>(_ expression: @autoclosure () throws -> T,
                    errorTransform: (Error) -> Error) throws -> T {
        do {
            return try expression()
        } catch {
            throw errorTransform(error)
        }
    }
}
