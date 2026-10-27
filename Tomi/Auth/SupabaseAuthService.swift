import Foundation
import OSLog

/// Sign-in through Supabase Auth's token endpoint, without a third-party SDK.
/// An actor, so two calls that both find the token expired renew it once, not twice with the same refresh token.
actor SupabaseAuthService: AuthService {
    private static let logger = Logger(category: .auth)

    private let client: SupabaseTokenClient
    private let store: any TokenStore
    private let now: @Sendable () -> Date

    init(client: SupabaseTokenClient, store: any TokenStore, now: @escaping @Sendable () -> Date) {
        self.client = client
        self.store = store
        self.now = now
    }

    func isSignedIn() async -> Bool {
        let session = try? store.load()
        return session != nil
    }

    func signIn(with identity: AppleIdentity) async throws {
        let grant = SupabaseGrant.appleIDToken(idToken: identity.idToken, rawNonce: identity.rawNonce)
        try store.save(try await client.session(for: grant, at: now()))
    }

    func signIn(email: String, password: String) async throws {
        let grant = SupabaseGrant.emailPassword(email: email, password: password)
        try store.save(try await client.session(for: grant, at: now()))
    }

    func createAccount(email: String, password: String) async throws -> SignUpResult {
        let result = try await client.createAccount(email: email, password: password, at: now())
        if case .authenticated(let session) = result {
            try store.save(session)
            return .authenticated
        }
        return .emailConfirmationRequired
    }

    func sendPasswordReset(to email: String) async throws {
        try await client.sendPasswordReset(to: email)
    }

    func accessToken() async throws -> String {
        let session = try currentSession()
        if session.needsRefresh(at: now()) {
            return try await renewed(session).accessToken
        }
        return session.accessToken
    }

    func renewedAccessToken() async throws -> String {
        try await renewed(try currentSession()).accessToken
    }

    nonisolated func accountID() -> String? {
        let session = try? store.load()
        return session?.accountID
    }

    func signOut() async throws {
        try store.delete()
    }

    private func currentSession() throws -> AuthSession {
        guard let session = try store.load() else {
            throw BackendError.notSignedIn
        }
        return session
    }

    /// A refused refresh means the session is over: it is forgotten and the cook signs in again.
    private func renewed(_ session: AuthSession) async throws -> AuthSession {
        do {
            let fresh = try await client.session(for: .refreshToken(session.refreshToken), at: now())
            try store.save(fresh)
            return fresh
        } catch BackendError.server {
            Self.logger.error("The session could not be renewed; the cook must sign in again.")
            try store.delete()
            throw BackendError.notSignedIn
        }
    }
}
