/// Signing the cook in and keeping a valid access token for the server.
/// Supabase email and Apple authentication in the app; a fake for previews and UI tests.
nonisolated protocol AuthService: Sendable {
    func isSignedIn() async -> Bool
    /// Exchanges Apple's identity token for a Supabase session and keeps it.
    func signIn(with identity: AppleIdentity) async throws
    func signIn(email: String, password: String) async throws
    func createAccount(email: String, password: String) async throws -> SignUpResult
    func sendPasswordReset(to email: String) async throws
    /// A token that is valid now, renewed first when it is about to run out. Throws `notSignedIn` without a session.
    func accessToken() async throws -> String
    /// A new token even if the old one looked valid: the server refused the old one with 401.
    func renewedAccessToken() async throws -> String
    /// A token only for the specified account, including after renewal.
    func accessToken(for account: String, renewing: Bool) async throws -> String
    func signOut() async throws
    /// The id of the account that is signed in, or nil when nobody is. Read from the saved session, so it is known
    /// offline too. A cook is saved under it, and only that account's session sends the cook.
    func accountID() -> String?
}
