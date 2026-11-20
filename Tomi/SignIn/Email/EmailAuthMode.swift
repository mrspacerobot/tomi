import SwiftUI

/// The three email-auth tasks available from Tomi's first screen.
enum EmailAuthMode: Equatable {
    case signIn
    case createAccount
    case passwordRecovery
}

extension EmailAuthMode {
    var submitTitle: LocalizedStringResource {
        switch self {
        case .signIn: .authSignIn
        case .createAccount: .authCreateSubmit
        case .passwordRecovery: .authResetSubmit
        }
    }

    var pageTitle: LocalizedStringResource {
        switch self {
        case .signIn: .openingEmailTitle
        case .createAccount: .authCreateAccount
        case .passwordRecovery: .authForgotPassword
        }
    }

    var submitIdentifier: String {
        switch self {
        case .signIn: "auth-sign-in"
        case .createAccount: "auth-create-submit"
        case .passwordRecovery: "auth-reset-submit"
        }
    }

    var noticeIdentifier: String {
        switch self {
        case .signIn: "auth-sign-in-message"
        case .createAccount: "auth-confirmation-message"
        case .passwordRecovery: "auth-recovery-message"
        }
    }
}
