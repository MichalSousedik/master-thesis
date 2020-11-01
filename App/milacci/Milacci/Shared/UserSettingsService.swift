//
//  UserDetailService.swift
//  Milacci
//
//  Created by Michal Sousedik on 18/10/2020.
//  Copyright © 2020 Michal Sousedik. All rights reserved.
//

import Foundation

protocol UserSettingsAPI {

    var accessToken: String? { get }
    var refreshToken: String? { get }
    var userId: Int { get }

    func getSignInModel() -> SignInResponse?
    func saveCredentials(credentials: Credentials)
    func saveUser(user: User)
    func clearAll()
    func clearAccessToken()
}

public class UserSettingsService {

    private struct Keys {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let expiresIn = "expiresIn"
        static let userId = "userId"
        static let roles = "roles"
    }

    static let shared: UserSettingsService = UserSettingsService()

    private init() {}

}

extension UserSettingsService: UserSettingsAPI {

    var userId: Int {
        return UserDefaults.standard.integer(forKey: Keys.userId)
    }

    var accessToken: String? {
        return UserDefaults.standard.string(forKey: Keys.accessToken)
    }

    var refreshToken: String? {
        return UserDefaults.standard.string(forKey: Keys.refreshToken)
    }

    func getSignInModel() -> SignInResponse? {

        let expiresIn: Int = UserDefaults.standard.integer(forKey: Keys.expiresIn)

        guard let accessToken = accessToken ?? "",
              let refreshToken = refreshToken,
              expiresIn != 0,
              let rolesData = UserDefaults.standard.data(forKey: Keys.roles),
              let roles = try? JSONDecoder().decode([Role].self, from: rolesData),
              userId != 0 else {
            return nil
        }
        return SignInResponse(user: User(id: userId, roles: roles),
                          credentials: Credentials(
                            accessToken: accessToken,
                            refreshToken: refreshToken,
                            expiresIn: expiresIn)
        )
    }

    func saveCredentials(credentials: Credentials) {
        UserDefaults.standard.set(credentials.accessToken, forKey: Keys.accessToken)
        UserDefaults.standard.set(credentials.refreshToken, forKey: Keys.refreshToken)
        UserDefaults.standard.set(credentials.expiresIn, forKey: Keys.expiresIn)
    }

    func saveUser(user: User) {
        UserDefaults.standard.set(user.id, forKey: Keys.userId)
        let arrayOfData: [Role] = user.roles ?? []
        let data = try? JSONEncoder().encode(arrayOfData)
        UserDefaults.standard.set(data, forKey: Keys.roles)
    }

    func clearAll() {
        UserDefaults.standard.removeObject(forKey: Keys.accessToken)
        UserDefaults.standard.removeObject(forKey: Keys.refreshToken)
        UserDefaults.standard.removeObject(forKey: Keys.expiresIn)
        UserDefaults.standard.removeObject(forKey: Keys.userId)

    }

    func clearAccessToken() {
        UserDefaults.standard.removeObject(forKey: Keys.accessToken)

    }

}
