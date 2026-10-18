/// Whether email sign-up returned an active session or needs email confirmation first.
nonisolated enum SignUpResult: Equatable, Sendable {
    case authenticated
    case emailConfirmationRequired
}

/// The sign-up response carries a session only when the project does not require email confirmation.
nonisolated enum SupabaseSignUpResult: Sendable {
    case authenticated(AuthSession)
    case emailConfirmationRequired
}
