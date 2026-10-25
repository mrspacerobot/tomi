import Foundation

/// Optional token fields distinguish confirmed sign-up sessions from email-confirmation responses.
nonisolated struct SupabaseSignUpResponse: Decodable, Sendable {
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }

    var hasSessionFields: Bool {
        accessToken != nil || refreshToken != nil || expiresIn != nil
    }

    func result(receivedAt now: Date) throws -> SupabaseSignUpResult {
        guard hasSessionFields else {
            return .emailConfirmationRequired
        }
        guard let accessToken, let refreshToken, let expiresIn else {
            throw BackendError.unreadableResponse(status: 200)
        }
        let expiry = now.addingTimeInterval(TimeInterval(expiresIn))
        return .authenticated(AuthSession(accessToken: accessToken, refreshToken: refreshToken, expiresAt: expiry))
    }
}
