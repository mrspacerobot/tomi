import Foundation
import Testing

@testable import Tomi

/// Sign in with Apple through Supabase's token endpoint, and keeping the session fresh.
@Suite struct SupabaseAuthTests {
    static let tokens = #"{"access_token": "a1", "refresh_token": "r1", "expires_in": 3600, "token_type": "bearer"}"#
    let start = Date(timeIntervalSince1970: 1_000_000)

    func service(_ answers: [StubTransport.Answer], store: InMemoryTokenStore) -> (SupabaseAuthService, StubTransport) {
        let transport = StubTransport(answers)
        let client = SupabaseTokenClient(
            supabaseURL: URL(string: "https://project.supabase.test")!,
            publishableKey: "publishable",
            transport: transport
        )
        let now = start
        return (SupabaseAuthService(client: client, store: store, now: { now }), transport)
    }

    @Test func appleIdentityIsExchangedWithTheRawNonce() async throws {
        let store = InMemoryTokenStore()
        let (auth, transport) = service([.init(status: 200, body: Self.tokens)], store: store)
        try await auth.signIn(with: AppleIdentity(idToken: "apple-token", rawNonce: "raw"))
        let request = try #require(transport.requests.first)
        #expect(request.url?.absoluteString == "https://project.supabase.test/auth/v1/token?grant_type=id_token")
        #expect(request.value(forHTTPHeaderField: "apikey") == "publishable")
        let body = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        #expect(body == #"{"id_token":"apple-token","nonce":"raw","provider":"apple"}"#)
        #expect(try store.load() == AuthSession(accessToken: "a1", refreshToken: "r1", expiresAt: start + 3600))
    }

    @Test func aValidTokenIsUsedAsItIs() async throws {
        let store = InMemoryTokenStore(AuthSession(accessToken: "a0", refreshToken: "r0", expiresAt: start + 600))
        let (auth, transport) = service([], store: store)
        #expect(try await auth.accessToken() == "a0")
        #expect(transport.requests.isEmpty)
    }

    @Test func aTokenAboutToRunOutIsRenewedWithTheRefreshToken() async throws {
        let store = InMemoryTokenStore(AuthSession(accessToken: "a0", refreshToken: "r0", expiresAt: start + 30))
        let (auth, transport) = service([.init(status: 200, body: Self.tokens)], store: store)
        #expect(try await auth.accessToken() == "a1")
        let request = try #require(transport.requests.first)
        #expect(request.url?.query() == "grant_type=refresh_token")
        #expect(request.httpBody == Data(#"{"refresh_token":"r0"}"#.utf8))
    }

    @Test func aRefusedRenewalSignsTheCookOut() async throws {
        let store = InMemoryTokenStore(AuthSession(accessToken: "a0", refreshToken: "r0", expiresAt: start))
        let (auth, _) = service([.init(status: 400, body: "{}")], store: store)
        await #expect(throws: BackendError.notSignedIn) {
            try await auth.accessToken()
        }
        #expect(try store.load() == nil)
    }

    @Test func withoutASessionNobodyIsSignedIn() async {
        let (auth, _) = service([], store: InMemoryTokenStore())
        #expect(await !auth.isSignedIn())
        await #expect(throws: BackendError.notSignedIn) {
            try await auth.accessToken()
        }
    }

    @Test func theNonceSentToAppleIsTheSHA256OfTheRawOne() {
        #expect(AppleNonce(raw: "abc").sha256 == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
        #expect(AppleNonce.random().raw.count == 64)
        #expect(AppleNonce.random() != AppleNonce.random())
    }
}
