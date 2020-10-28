
import Foundation

// MARK: - SignInModel
struct SignInModel: Codable {
    let user: User
    let credentials: Credentials
}

// MARK: - Credentials
struct Credentials: Codable {
    let accessToken, refreshToken: String
    let expiresIn: Int
}

// MARK: - Meta
struct Meta: Codable {
}

// MARK: - User
struct User: Codable {
    let id: Int
    let roles: [Role]?
}

enum Role: String, Codable {
    case user = "user"
    case teamLeader = "teamLeader"
    case admin = "admin"
}

