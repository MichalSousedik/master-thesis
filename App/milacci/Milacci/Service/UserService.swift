//
//  UserService.swift
//  Milacci
//
//  Created by Michal Sousedik on 02/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import Alamofire

protocol UserAPI {
    func fetchDetail(id: Int) -> Single<UserDetail>
    func fetch(page: Int, teamLeaderId: Int?, searchedText: String?) -> Single<EmployeesResponse>
}

class UserService: UserAPI {

    static let shared: UserAPI = UserService()
    private lazy var httpService = SecuredHttpService()

    func fetchDetail(id: Int) -> Single<UserDetail> {
//        mockDetailEndpoint()
        return Single.create{ [httpService] (single) -> Disposable in
            do {
                try UserHttpRouter.detail(id: id)
                    .request(usingHttpService: httpService)
                    .responseJSON{ result in
                        HttpResponseHandler.handle(result: result, completion: { (item, error) in
                            if let error = error {
                                single(.error(error))
                            } else if let item = item {
                                single(.success(item))
                            }
                        }, type: UserDetail.self)
                }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }

            return Disposables.create()
        }
    }

    func fetch(page: Int, teamLeaderId: Int?, searchedText: String?) -> Single<EmployeesResponse> {
        self.mockFetch()
        let encodedText = searchedText?.addingPercentEncoding(withAllowedCharacters:
                                                               CharacterSet.urlQueryAllowed)
        return Single.create{ [httpService] (single) -> Disposable in
            do {
                try UserHttpRouter.fetch(offset: (page - 1)*10, teamLeaderId: teamLeaderId, searchedText: encodedText)
                    .request(usingHttpService: httpService)
                    .responseJSON { result in
                        HttpResponseHandler.handle(result: result, completion: { (items, error) in
                            if let error = error {
                                single(.error(error))
                            } else if let items = items {
                                single(.success(items))
                            }
                        }, type: EmployeesResponse.self)
                    }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }

            return Disposables.create()
        }
    }

}
