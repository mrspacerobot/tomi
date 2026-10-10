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
        if let photo = error as? JPEGConversionError {
            return photo.problemText
        }
        guard let backend = error as? BackendError else {
            return .problemGeneric
        }
        return backend.problemText
    }

    private static func serverMessage(of error: any Error) -> String {
        guard case .server(_, let apiError) = error as? BackendError else {
            return ""
        }
        return apiError.message
    }
}
