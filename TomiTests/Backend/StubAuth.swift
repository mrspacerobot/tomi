import Synchronization

@testable import Tomi

/// Sign-in that hands out "old" until asked to renew, then "new", and counts the renewals.
final class StubAuth: AuthService {
    private let renewals = Mutex(0)

    var renewalCount: Int {
        renewals.withLock { $0 }
    }

    func isSignedIn() async -> Bool { true }
    func signIn(with identity: AppleIdentity) async throws {}
    func signIn(email: String, password: String) async throws {}
    func createAccount(email: String, password: String) async throws -> SignUpResult { .emailConfirmationRequired }
    func sendPasswordReset(to email: String) async throws {}
    func signOut() async throws {}

    func accessToken() async throws -> String {
        if renewalCount == 0 {
            return "old"
        }
        return "new"
    }

    func renewedAccessToken() async throws -> String {
        renewals.withLock { $0 += 1 }
        return "new"
    }
}
