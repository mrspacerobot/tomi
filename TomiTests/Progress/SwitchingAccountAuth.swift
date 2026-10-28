import Synchronization

@testable import Tomi

final class SwitchingAccountAuth: AuthService {
    private let account = Mutex<String?>("cook-a")

    func switchTo(_ id: String?) { account.withLock { $0 = id } }
    func accountID() -> String? { account.withLock { $0 } }
    func isSignedIn() async -> Bool { accountID() != nil }
    func signIn(with identity: AppleIdentity) async throws {}
    func signIn(email: String, password: String) async throws {}
    func createAccount(email: String, password: String) async throws -> SignUpResult { .emailConfirmationRequired }
    func sendPasswordReset(to email: String) async throws {}
    func accessToken() async throws -> String {
        guard let account = accountID() else { throw BackendError.notSignedIn }
        return account
    }
    func renewedAccessToken() async throws -> String { try await accessToken() }
    func accessToken(for account: String, renewing: Bool) async throws -> String {
        guard accountID() == account else { throw BackendError.notSignedIn }
        return account
    }
    func signOut() async throws { switchTo(nil) }
}
