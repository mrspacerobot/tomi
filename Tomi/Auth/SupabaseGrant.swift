import Foundation

/// The two ways the app asks Supabase for tokens, as the body and `grant_type` of `POST /auth/v1/token`.
nonisolated enum SupabaseGrant: Sendable {
    /// Sign in with the identity token Apple gave, and the raw nonce whose SHA-256 was sent to Apple.
    case appleIDToken(idToken: String, rawNonce: String)
    /// Swap a refresh token for a new session. A refresh token works once.
    case refreshToken(String)

    static let appleProvider = "apple"

    var grantType: String {
        switch self {
        case .appleIDToken: "id_token"
        case .refreshToken: "refresh_token"
        }
    }

    var body: [String: String] {
        switch self {
        case .appleIDToken(let idToken, let rawNonce):
            ["provider": Self.appleProvider, "id_token": idToken, "nonce": rawNonce]
        case .refreshToken(let token):
            ["refresh_token": token]
        }
    }
}
