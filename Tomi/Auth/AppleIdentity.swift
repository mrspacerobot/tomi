/// What Sign in with Apple hands over: Apple's identity token and the raw nonce whose hash Apple signed into it.
nonisolated struct AppleIdentity: Equatable, Sendable {
    let idToken: String
    let rawNonce: String
}
