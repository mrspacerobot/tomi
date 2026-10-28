extension SupabaseAuthService {
    /// A refresh that returns after sign-out or another sign-in must not replace the current session.
    func keepRenewal(_ fresh: AuthSession, replacing session: AuthSession) throws {
        guard try currentSession() == session, fresh.accountID == session.accountID else {
            throw BackendError.notSignedIn
        }
        try store.save(fresh)
    }
}
