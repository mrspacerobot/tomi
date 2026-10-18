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
}
