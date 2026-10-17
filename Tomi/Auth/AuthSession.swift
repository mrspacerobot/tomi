import Foundation

/// The cook's Supabase session: the access token every call to the server carries, and the refresh token
/// that buys a new one. Kept in the Keychain, never in the store or a log.
nonisolated struct AuthSession: Codable, Equatable, Sendable {
    /// Refresh this long before the access token runs out, so a call never leaves with a token about to expire.
    static let refreshMargin: TimeInterval = 60

    let accessToken: String
    let refreshToken: String
    let expiresAt: Date

    /// Whether the access token should be refreshed before it is used at this moment.
    func needsRefresh(at now: Date) -> Bool {
        now.addingTimeInterval(Self.refreshMargin) >= expiresAt
    }
}
