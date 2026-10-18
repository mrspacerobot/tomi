import Foundation
import Testing

@testable import Tomi

/// Email and password sign-in, account creation and password reset through Supabase Auth.
@Suite struct SupabaseEmailAuthTests {
    let helper = SupabaseAuthTests()

    @Test func emailAndPasswordCreateASupabaseSession() async throws {
        let store = InMemoryTokenStore()
        let (auth, transport) = helper.service([.init(status: 200, body: SupabaseAuthTests.tokens)], store: store)
        try await auth.signIn(email: "cook@example.com", password: "secret")
        let request = try #require(transport.requests.first)
        #expect(request.url?.query() == "grant_type=password")
        #expect(
            String(bytes: request.httpBody ?? Data(), encoding: .utf8)
                == #"{"email":"cook@example.com","password":"secret"}"#
        )
        #expect(try store.load()?.accessToken == "a1")
    }

    @Test func accountCreationWaitsForEmailConfirmationWhenNoSessionIsReturned() async throws {
        let store = InMemoryTokenStore()
        let (auth, transport) = helper.service(
            [.init(status: 200, body: #"{"id":"cook","email":"cook@example.com"}"#)],
            store: store
        )
        let result = try await auth.createAccount(email: "cook@example.com", password: "secret")
        #expect(result == .emailConfirmationRequired)
        #expect(try store.load() == nil)
        #expect(transport.requests.first?.url?.path == "/auth/v1/signup")
    }

    @Test func passwordResetRequestsAnEmailWithoutLoggingIn() async throws {
        let store = InMemoryTokenStore()
        let (auth, transport) = helper.service([.init(status: 200, body: "{}")], store: store)
        try await auth.sendPasswordReset(to: "cook@example.com")
        let request = try #require(transport.requests.first)
        #expect(request.url?.path == "/auth/v1/recover")
        #expect(String(bytes: request.httpBody ?? Data(), encoding: .utf8) == #"{"email":"cook@example.com"}"#)
        #expect(try store.load() == nil)
    }
}
