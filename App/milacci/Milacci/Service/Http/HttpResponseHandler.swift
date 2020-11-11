//
//  HttpResponseHandler.swift
//  Milacci
//
//  Created by Michal Sousedik on 01/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Alamofire

class HttpResponseHandler {

    static func handle<T: Decodable>(result: AFDataResponse<Any>, completion: @escaping (T?, Error?) -> Void, type: T.Type) {
        if let error = result.error {
            completion(nil, HttpResponseHandler.handleError(error: error, result: result))
        } else {
            do {
                let items = try HttpResponseHandler.parse(result: result, type: T.self)
                completion(items, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    private static func handleError(error: AFError, result: AFDataResponse<Any>) -> NetworkingError {
        if let afError = error.asAFError {
            switch afError {
            case .sessionTaskFailed(let sessionError):
                if let urlError = sessionError as? URLError, urlError.code == URLError.notConnectedToInternet {
                    return NetworkingError.deviceIsOffline
                }
            default: break
            }}

          return HttpResponseHandler.handleErrorStatusCodes(error: error, result: result)
    }

    private static func handleErrorStatusCodes(error: AFError, result: AFDataResponse<Any>) -> NetworkingError {
        switch error.responseCode {
        case 400:
            if let errorResponse = try? HttpResponseHandler.parse(result: result, type: ErrorResponse.self) {
                return NetworkingError.custom(message: errorResponse.error.message)
            } else {
                return NetworkingError.custom(message: L10n.notAbleToParseErrorResponse)
            }
        case 401:
            return NetworkingError.unauthorized
        case 403:
            return NetworkingError.forbiden
        case 404:
            return NetworkingError.resourceNotFound
        case 500:
            return NetworkingError.serverError(error)
        default:
            return NetworkingError.custom(message: error.localizedDescription)
        }
    }

    private static func parse<T: Decodable>(result: AFDataResponse<Any>, type: T.Type) throws -> T {
        guard
            let data = result.data else {
            throw NetworkingError.custom(message: L10n.dataCouldnTBeExtractedFromResult)
        }

        return try perform(JSONDecoder().decode(T.self, from: data))
            {NetworkingError.decodingFailed($0)}
    }

    private static func perform<T>(_ expression: @autoclosure () throws -> T,
                                   errorTransform: (Error) -> Error) throws -> T {
        do {
            return try expression()
        } catch {
            print(error)
            throw errorTransform(error)
        }
    }

    private init(){

    }

}
