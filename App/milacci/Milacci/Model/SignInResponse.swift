
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

struct UserDetail: Codable {
    let name: String?
    let surname: String?
    let jobTitle: JobTitle?
    let degree: String?
    let dateOfBirth: String?
    let hourlyCapacity: Int?
    let phoneNumber: String?
    let contactEmail: String?
    let workType: WorkType?
}

extension UserDetail {

    var formattedDateOfBirth: String? {
        guard let dateOfBirth = dateOfBirth else {return nil}
        let parts = dateOfBirth.components(separatedBy: "-")
        let year = parts[0]
        let month = parts[1]
        let day = parts[2]
        return "\(day). \(month). \(year)"
    }

}

enum WorkType: String, Codable {
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

enum JobTitle: String, Codable {
    case backend = "backend"
    case frontend = "frontend"
    case android = "android"
    case ios = "ios"
    case projectManager = "projectManager"
    case devops = "devops"
    case tester = "tester"
    case design = "design"
    case marketing = "marketing"
    case hr = "hr"
    case office = "office"
    case sales = "sales"
    case accounts = "accounts"
    case boss = "boss"
}

extension JobTitle {

    var description: String {
        switch self{
        case .backend: return L10n.backend
        case .frontend: return L10n.frontend
        case .android: return L10n.android
        case .ios: return L10n.ios
        case .projectManager: return L10n.projectManager
        case .devops: return L10n.devops
        case .tester: return L10n.tester
        case .design: return L10n.design
        case .marketing: return L10n.marketing
        case .hr: return L10n.hr
        case .office: return L10n.office
        case .sales: return L10n.sales
        case .accounts: return L10n.accounts
        case .boss: return L10n.boss
        }
    }

}

enum Role: String, Codable {
    case user = "user"
    case teamLeader = "teamLeader"
    case admin = "admin"
}

