import Synchronization

/// Sign-in for previews and UI tests: any identity signs in, and the token is a fixed word.
nonisolated final class FakeAuthService: AuthService {
    static let token = "fake-access-token"

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

    func accessToken() async throws -> String {
        guard await isSignedIn() else {
            throw BackendError.notSignedIn
        }
        return Self.token
    }

    func renewedAccessToken() async throws -> String {
        try await accessToken()
    }

    func signOut() async throws {
        signedIn.withLock { $0 = false }
    }
}
