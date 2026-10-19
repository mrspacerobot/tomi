import Foundation

/// An error as the server sends it: `{"error": {"code", "message", "details"}}`.
public struct APIError: Error, Hashable, Sendable {
    /// The code as sent. One this build does not know is kept, and the server's message is shown for it.
    public let codeName: String
    /// The server's words, for the cook when the app has none of its own for the code.
    public let message: String
    /// For `version_conflict`: the profile as it is now, to apply the cook's change to again.
    public var currentProfile: ProfileEnvelope?

    public init(codeName: String, message: String) {
        self.codeName = codeName
        self.message = message
    }

    public var code: APIErrorCode? {
        APIErrorCode(rawValue: codeName)
    }

    /// The error in a response body, or nil when the body is not one.
    public static func decode(from data: Data) -> APIError? {
        guard let body = try? JSONDecoder().decode(APIErrorBody.self, from: data) else {
            return nil
        }
        var error = APIError(codeName: body.error.code, message: body.error.message)
        error.currentProfile = body.error.details?.current
        return error
    }
}
