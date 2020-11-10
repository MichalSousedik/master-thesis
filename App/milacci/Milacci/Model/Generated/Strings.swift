// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Access token not provided
  internal static let accessTokenNotProvided = L10n.tr("Localizable", "Access Token not provided")
  /// Account was not authorized
  internal static let accountWasNotAuthorized = L10n.tr("Localizable", "Account was not authorized")
  /// Accounts
  internal static let accounts = L10n.tr("Localizable", "Accounts")
  /// Agreement
  internal static let agreement = L10n.tr("Localizable", "Agreement")
  /// Android Developer
  internal static let android = L10n.tr("Localizable", "Android")
  /// Approved
  internal static let approved = L10n.tr("Localizable", "Approved")
  /// April
  internal static let april = L10n.tr("Localizable", "April")
  /// August
  internal static let august = L10n.tr("Localizable", "August")
  /// Backend Developer
  internal static let backend = L10n.tr("Localizable", "Backend")
  /// Boss
  internal static let boss = L10n.tr("Localizable", "Boss")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "Cancel")
  /// Kč
  internal static let crowns = L10n.tr("Localizable", "Crowns")
  /// Data couldn't be extracted from result
  internal static let dataCouldnTBeExtractedFromResult = L10n.tr("Localizable", "Data couldn't be extracted from result")
  /// December
  internal static let december = L10n.tr("Localizable", "December")
  /// Designer
  internal static let design = L10n.tr("Localizable", "Design")
  /// Device is offline
  internal static let deviceIsOffline = L10n.tr("Localizable", "Device is offline")
  /// DevOps
  internal static let devops = L10n.tr("Localizable", "Devops")
  /// Employment Contract
  internal static let employmentContract = L10n.tr("Localizable", "Employment Contract")
  /// Error occured
  internal static let errorOccured = L10n.tr("Localizable", "Error occured")
  /// February
  internal static let february = L10n.tr("Localizable", "February")
  /// Request coudn't be completed:
  internal static let fetchingDataResultedInError = L10n.tr("Localizable", "Fetching data resulted in error")
  /// Access forbidden
  internal static let forbidden = L10n.tr("Localizable", "Forbidden")
  /// Frontend Developer
  internal static let frontend = L10n.tr("Localizable", "Frontend")
  /// Human Resources
  internal static let hr = L10n.tr("Localizable", "HR")
  /// Invoice is already approved
  internal static let invoiceIsAlreadyApproved = L10n.tr("Localizable", "Invoice is already approved")
  /// Invoice is already paid
  internal static let invoiceIsAlreadyPaid = L10n.tr("Localizable", "Invoice is already paid")
  /// Invoices
  internal static let invoices = L10n.tr("Localizable", "Invoices")
  /// iOS Developer
  internal static let ios = L10n.tr("Localizable", "IOS")
  /// January
  internal static let january = L10n.tr("Localizable", "January")
  /// July
  internal static let july = L10n.tr("Localizable", "July")
  /// June
  internal static let june = L10n.tr("Localizable", "June")
  /// March
  internal static let march = L10n.tr("Localizable", "March")
  /// Marketing specialist
  internal static let marketing = L10n.tr("Localizable", "Marketing")
  /// May
  internal static let may = L10n.tr("Localizable", "May")
  /// My Team
  internal static let myTeam = L10n.tr("Localizable", "My Team")
  /// New
  internal static let new = L10n.tr("Localizable", "New")
  /// Uploading document is not permited
  internal static let noActionAvailable = L10n.tr("Localizable", "No action available")
  /// No Internet Connection
  internal static let noInternetConnection = L10n.tr("Localizable", "No Internet Connection")
  /// Not able to parse error response.
  internal static let notAbleToParseErrorResponse = L10n.tr("Localizable", "Not able to parse error response")
  /// November
  internal static let november = L10n.tr("Localizable", "November")
  /// October
  internal static let october = L10n.tr("Localizable", "October")
  /// Office Manager
  internal static let office = L10n.tr("Localizable", "Office")
  /// Paid
  internal static let paid = L10n.tr("Localizable", "Paid")
  /// Profile
  internal static let profile = L10n.tr("Localizable", "Profile")
  /// Project Manager
  internal static let projectManager = L10n.tr("Localizable", "Project Manager")
  /// Received data couldn't be loaded because they are in a wrong format
  internal static let receivedDataCouldnTBeLoadedBecauseTheyAreInAWrongFormat = L10n.tr("Localizable", "Received data couldn't be loaded because they are in a wrong format")
  /// Registration Number
  internal static let registrationNumber = L10n.tr("Localizable", "Registration Number")
  /// Resource was not found
  internal static let resourceWasNotFound = L10n.tr("Localizable", "Resource was not found")
  /// Retry
  internal static let retry = L10n.tr("Localizable", "Retry")
  /// Sales
  internal static let sales = L10n.tr("Localizable", "Sales")
  /// Searched data couldn't be located
  internal static let searchedDataCouldnTBeLocated = L10n.tr("Localizable", "Searched data couldn't be located")
  /// Selected URL is not accessible
  internal static let selectedURLIsNotAccessible = L10n.tr("Localizable", "Selected URL is not accessible")
  /// September
  internal static let september = L10n.tr("Localizable", "September")
  /// Server got into trouble
  internal static let serverGotIntoTrouble = L10n.tr("Localizable", "Server got into trouble")
  /// Tester
  internal static let tester = L10n.tr("Localizable", "Tester")
  /// Unknown month
  internal static let unknownMonth = L10n.tr("Localizable", "Unknown month")
  /// User's work type for selected month is 'agreement'
  internal static let userWorkTypeIsAgreement = L10n.tr("Localizable", "User work type is agreement")
  /// ViewController Delegate is not present
  internal static let vcDelegateIsNotPresent = L10n.tr("Localizable", "VC Delegate is not present")
  /// Wage
  internal static let wage = L10n.tr("Localizable", "Wage")
  /// Waiting
  internal static let waiting = L10n.tr("Localizable", "Waiting")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
