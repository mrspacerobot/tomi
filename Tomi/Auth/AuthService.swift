/// Signing the cook in and keeping a valid access token for the server.
/// Supabase with Sign in with Apple in the app; a fake for previews and UI tests.
nonisolated protocol AuthService: Sendable {
    func isSignedIn() async -> Bool
    /// Exchanges Apple's identity token for a Supabase session and keeps it.
    func signIn(with identity: AppleIdentity) async throws
    /// A token that is valid now, renewed first when it is about to run out. Throws `notSignedIn` without a session.
    func accessToken() async throws -> String
    /// A new token even if the old one looked valid: the server refused the old one with 401.
    func renewedAccessToken() async throws -> String
    func signOut() async throws
}
