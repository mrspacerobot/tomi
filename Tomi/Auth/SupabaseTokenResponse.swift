import Foundation

/// What Supabase's `POST /auth/v1/token` answers for any grant. Only the tokens and their lifetime are read.
nonisolated struct SupabaseTokenResponse: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String
    /// Seconds until the access token should be renewed.
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }

    /// The session this answer starts, timed from the moment it arrived.
    func session(receivedAt now: Date) -> AuthSession {
        let expiry = now.addingTimeInterval(TimeInterval(expiresIn))
        return AuthSession(accessToken: accessToken, refreshToken: refreshToken, expiresAt: expiry)
    }
}
