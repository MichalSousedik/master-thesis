//
//  HourRateService.swift
//  Milacci
//
//  Created by Michal Sousedik on 17/11/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import RxSwift
import Alamofire

protocol HourRateAPI {
    func create(value: Double, since: Date, userId: Int) -> Single<HourRate>
    func stats(period: Date) -> Single<[HourRateStat]>
}

class HourRateService: HourRateAPI {

    static let shared: HourRateAPI = HourRateService()
    private lazy var httpService = SecuredHttpService()

    func create(value: Double, since: Date, userId: Int) -> Single<HourRate> {
//        mockCreate()
        return Single.create{ [httpService] (single) -> Disposable in
            do {
                try HourRateHttpRouter.create(value: value, since: since, userId: userId)
                    .request(usingHttpService: httpService)
                    .responseJSON{ result in
                        HttpResponseHandler.handle(result: result, completion: { (item, error) in
                            if let error = error {
                                single(.error(error))
                            } else if let item = item {
                                single(.success(item))
                            }
                        }, type: HourRate.self)
                }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }

            return Disposables.create()
        }
    }

    func stats(period: Date) -> Single<[HourRateStat]> {
//        mockStats()
        return Single.create{ [httpService] (single) -> Disposable in
            do {
                try HourRateHttpRouter.stats(period: period)
                    .request(usingHttpService: httpService)
                    .responseJSON{ result in
                        HttpResponseHandler.handle(result: result, completion: { (item, error) in
                            if let error = error {
                                single(.error(error))
                            } else if let item = item {
                                single(.success(item))
                            }
                        }, type: [HourRateStat].self)
                }
            } catch {
                single(.error(NetworkingError.serverError(error)))
            }

            return Disposables.create()
        }
    }
}
