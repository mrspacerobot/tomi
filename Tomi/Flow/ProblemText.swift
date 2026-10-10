import Foundation
import TomiCore

/// The words for something that went wrong: Tomi's own for every error the app knows,
/// the server's message for a code this build does not know.
struct ProblemText {
    let resource: LocalizedStringResource?
    let serverMessage: String

    init(_ error: any Error) {
        resource = Self.resource(for: error)
        serverMessage = Self.serverMessage(of: error)
    }

    private static func resource(for error: any Error) -> LocalizedStringResource? {
        guard let backend = error as? BackendError else {
            return .problemGeneric
        }
        switch backend {
        case .notConfigured: return .problemNotConfigured
        case .notSignedIn: return .problemSignedOut
        case .unreachable: return .problemUnreachable
        case .unreadableResponse: return .problemGeneric
        case .server(_, let apiError): return resource(for: apiError)
        }
    }

    private static func resource(for error: APIError) -> LocalizedStringResource? {
        guard let code = error.code else {
            return nil
        }
        return code.problemText
    }

    private static func serverMessage(of error: any Error) -> String {
        guard case .server(_, let apiError) = error as? BackendError else {
            return ""
        }
        return apiError.message
    }
}
