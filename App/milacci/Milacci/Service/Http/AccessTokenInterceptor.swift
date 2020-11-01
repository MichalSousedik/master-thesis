//
//  AccessTokenInterceptor.swift
//  Milacci
//
//  Created by Michal Sousedik on 01/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//
import Alamofire

class AccessTokenInterceptor {

    private let userSettingsAPI: UserSettingsAPI
    private let httpService: HttpService = AuthHttpService()
    private var accessToken: String? {
        return userSettingsAPI.accessToken
    }
    private var refreshToken: String? {
        return userSettingsAPI.refreshToken
    }
    private var isRefreshing = false

    init(userSettingsAPI: UserSettingsAPI) {
        self.userSettingsAPI = userSettingsAPI
    }

}

extension AccessTokenInterceptor: RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = accessToken {
            request.headers.update(.authorization(bearerToken: token))
        }
        completion(.success(request))
    }

}

extension AccessTokenInterceptor {

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }

        if statusCode == 401 {
            guard !isRefreshing else {
                return
            }
            self.refreshTokens { [userSettingsAPI] (signInModel, error) in
                if error != nil {
                    completion(.doNotRetry)
                    return
                }
                guard let signInModel = signInModel else {
                    completion(.doNotRetry)
                    return
                }
                userSettingsAPI.saveCredentials(credentials: signInModel.credentials)
                completion(.retry)
            }
        } else {
            completion(.doNotRetry)
        }

    }

}

private extension AccessTokenInterceptor {

    typealias RefreshCompletion = (_ tokenData: SignInResponse?, _ error: Error?) -> Void

    func refreshTokens(completion: @escaping RefreshCompletion) {
        self.isRefreshing = true
        do {
            try AuthHttpRouter.refreshToken(refreshToken: self.refreshToken ?? "")
                .request(usingHttpService: self.httpService)
                .responseJSON {[weak self] (dataResponse) in
                    self?.isRefreshing = false
                    if let error = dataResponse.error {
                        completion(nil, error)
                        return
                    }

                    guard let statusCode = dataResponse.response?.statusCode,
                          statusCode == 200 else { completion(nil, nil); return }
                    if let signInResponse = try? AuthService.parse(result: dataResponse) {
                        completion(signInResponse, nil)
                    }
                }
        } catch {
            completion(nil, error)
        }
    }

}
