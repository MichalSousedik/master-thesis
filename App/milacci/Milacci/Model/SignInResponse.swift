
import Foundation

struct SignInResponse: Codable {
    let user: User
    let credentials: Credentials
}

struct Credentials: Codable {
    let accessToken, refreshToken: String
    let expiresIn: Int
}

struct User: Codable {
    let id: Int
    let roles: [Role]?
}

enum Role: String, Codable {
    case user = "user"
    case teamLeader = "teamLeader"
    case admin = "admin"
}

