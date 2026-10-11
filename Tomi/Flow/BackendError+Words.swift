import Foundation

extension BackendError {
    /// Tomi's words for the error, or nil for a server error with a code this build does not know.
    nonisolated var problemText: LocalizedStringResource? {
        switch self {
        case .notConfigured: .problemNotConfigured
        case .notSignedIn: .problemSignedOut
        case .unreachable: .problemUnreachable
        case .unreadableResponse: .problemGeneric
        case .server: code?.problemText
        }
    }
}
