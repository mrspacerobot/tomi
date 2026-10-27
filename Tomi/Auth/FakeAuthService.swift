import Synchronization

/// Sign-in for previews and UI tests: any identity signs in, and the token is a fixed word.
nonisolated final class FakeAuthService: AuthService {
    static let token = "fake-access-token"
    static let account = "fake-account"

    private let signedIn: Mutex<Bool>

    init(signedIn: Bool = false) {
        self.signedIn = Mutex(signedIn)
    }

    func isSignedIn() async -> Bool {
        signedIn.withLock { $0 }
    }

    func signIn(with identity: AppleIdentity) async throws {
        signedIn.withLock { $0 = true }
    }

    func signIn(email: String, password: String) async throws {
        signedIn.withLock { $0 = true }
    }

    func createAccount(email: String, password: String) async throws -> SignUpResult {
        .emailConfirmationRequired
    }

    func sendPasswordReset(to email: String) async throws {}

    func accessToken() async throws -> String {
        guard await isSignedIn() else {
            throw BackendError.notSignedIn
        }
        return Self.token
    }

    func renewedAccessToken() async throws -> String {
        try await accessToken()
    }

    func accountID() -> String? {
        guard signedIn.withLock({ $0 }) else {
            return nil
        }
        return Self.account
    }

    func signOut() async throws {
        signedIn.withLock { $0 = false }
    }
}
