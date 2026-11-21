import Synchronization

/// Sign-in for previews and UI tests: any identity signs in, and the token is a fixed word.
nonisolated final class FakeAuthService: AuthService {
    static let token = "fake-access-token"
    static let account = "fake-account"
    static let otherAccount = "other-fake-account"

    private let signedIn: Mutex<Bool>
    private let accountName: String
    private let rejectsPassword: Bool

    init(signedIn: Bool = false, account: String = FakeAuthService.account, rejectsPassword: Bool = false) {
        self.signedIn = Mutex(signedIn)
        accountName = account
        self.rejectsPassword = rejectsPassword
    }

    func isSignedIn() async -> Bool {
        signedIn.withLock { $0 }
    }

    func signIn(with identity: AppleIdentity) async throws {
        signedIn.withLock { $0 = true }
    }

    func signIn(email: String, password: String) async throws {
        guard !rejectsPassword else { throw BackendError.notSignedIn }
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

    func accessToken(for account: String, renewing: Bool) async throws -> String {
        guard accountID() == account else { throw BackendError.notSignedIn }
        return Self.token
    }

    func accountID() -> String? {
        guard signedIn.withLock({ $0 }) else {
            return nil
        }
        return accountName
    }

    func signOut() async throws {
        signedIn.withLock { $0 = false }
    }
}
