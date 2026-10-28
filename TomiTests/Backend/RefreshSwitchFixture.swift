import Foundation

@testable import Tomi

struct RefreshSwitchFixture {
    let store: InMemoryTokenStore
    let replacement: AuthSession
    let auth: SupabaseAuthService

    init(status: Int) throws {
        let original = Self.session(account: "cook-a")
        replacement = Self.session(account: "cook-b")
        store = InMemoryTokenStore(original)
        let body = try Self.body(token: original.accessToken)
        let transport = SwitchingRefreshTransport(store: store, replacement: replacement, status: status, body: body)
        let client = SupabaseTokenClient(supabaseURL: APIHarness.base, publishableKey: "key", transport: transport)
        auth = SupabaseAuthService(client: client, store: store, now: { .october(27) })
    }

    private static func session(account: String) -> AuthSession {
        let token = AuthSessionAccountTests().token(claims: "{\"sub\":\"\(account)\"}")
        return AuthSession(accessToken: token, refreshToken: account, expiresAt: .october(27))
    }

    private static func body(token: String) throws -> Data {
        try JSONSerialization.data(withJSONObject: [
            "access_token": token, "refresh_token": "new", "expires_in": 3600, "token_type": "bearer",
        ])
    }
}
