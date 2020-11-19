
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

enum WorkType: String, Codable, CaseIterable {
    case registrationNumber = "registrationNumber"
    case agreement = "agreement"
    case employmentContract = "employmentContract"
}

extension WorkType {
    var description: String {
        switch self{
        case .registrationNumber: return L10n.registrationNumber
        case .agreement: return L10n.agreement
        case .employmentContract: return L10n.employmentContract
        }
    }
}

enum Role: String, Codable {
    case user = "user"
    case teamLeader = "teamLeader"
    case admin = "admin"
}

