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
  /// Approved
  internal static let approved = L10n.tr("Localizable", "Approved")
  /// April
  internal static let april = L10n.tr("Localizable", "April")
  /// August
  internal static let august = L10n.tr("Localizable", "August")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "Cancel")
  /// Kč
  internal static let crowns = L10n.tr("Localizable", "Crowns")
  /// Data couldn't be extracted from result
  internal static let dataCouldnTBeExtractedFromResult = L10n.tr("Localizable", "Data couldn't be extracted from result")
  /// December
  internal static let december = L10n.tr("Localizable", "December")
  /// Device is offline
  internal static let deviceIsOffline = L10n.tr("Localizable", "Device is offline")
  /// Error occured
  internal static let errorOccured = L10n.tr("Localizable", "Error occured")
  /// February
  internal static let february = L10n.tr("Localizable", "February")
  /// Fetching data resulted in error
  internal static let fetchingDataResultedInError = L10n.tr("Localizable", "Fetching data resulted in error")
  /// Access forbidden
  internal static let forbidden = L10n.tr("Localizable", "Forbidden")
  /// Invoices
  internal static let invoices = L10n.tr("Localizable", "Invoices")
  /// January
  internal static let january = L10n.tr("Localizable", "January")
  /// July
  internal static let july = L10n.tr("Localizable", "July")
  /// June
  internal static let june = L10n.tr("Localizable", "June")
  /// March
  internal static let march = L10n.tr("Localizable", "March")
  /// May
  internal static let may = L10n.tr("Localizable", "May")
  /// New
  internal static let new = L10n.tr("Localizable", "New")
  /// No Internet Connection
  internal static let noInternetConnection = L10n.tr("Localizable", "No Internet Connection")
  /// November
  internal static let november = L10n.tr("Localizable", "November")
  /// October
  internal static let october = L10n.tr("Localizable", "October")
  /// Paid
  internal static let paid = L10n.tr("Localizable", "Paid")
  /// Profile
  internal static let profile = L10n.tr("Localizable", "Profile")
  /// Received data couldn't be loaded because they are in a wrong format
  internal static let receivedDataCouldnTBeLoadedBecauseTheyAreInAWrongFormat = L10n.tr("Localizable", "Received data couldn't be loaded because they are in a wrong format")
  /// Resource was not found
  internal static let resourceWasNotFound = L10n.tr("Localizable", "Resource was not found")
  /// Retry
  internal static let retry = L10n.tr("Localizable", "Retry")
  /// Searched data couldn't be located
  internal static let searchedDataCouldnTBeLocated = L10n.tr("Localizable", "Searched data couldn't be located")
  /// Selected URL is not accessible
  internal static let selectedURLIsNotAccessible = L10n.tr("Localizable", "Selected URL is not accessible")
  /// September
  internal static let september = L10n.tr("Localizable", "September")
  /// Server got into trouble
  internal static let serverGotIntoTrouble = L10n.tr("Localizable", "Server got into trouble")
  /// Unknown month
  internal static let unknownMonth = L10n.tr("Localizable", "Unknown month")
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
