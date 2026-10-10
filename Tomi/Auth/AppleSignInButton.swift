import AuthenticationServices
import SwiftUI

/// Apple's own sign-in button. It asks Apple for an identity token bound to a fresh nonce and hands over
/// the token with the raw nonce, for Supabase. No name or email is asked for: Tomi does not need them.
struct AppleSignInButton: View {
    let onIdentity: (AppleIdentity) -> Void
    let onFailure: () -> Void
    @State private var nonce = AppleNonce.random()

    var body: some View {
        SignInWithAppleButton(.signIn, onRequest: prepare, onCompletion: finish)
            .signInWithAppleButtonStyle(.black)
            .frame(minHeight: TouchTarget.button)
            .accessibilityIdentifier("sign-in-apple")
    }

    private func prepare(_ request: ASAuthorizationAppleIDRequest) {
        nonce = AppleNonce.random()
        request.requestedScopes = []
        request.nonce = nonce.sha256
    }

    private func finish(_ result: Result<ASAuthorization, any Error>) {
        guard case .success(let authorization) = result, let identity = identity(in: authorization) else {
            onFailure()
            return
        }
        onIdentity(identity)
    }

    private func identity(in authorization: ASAuthorization) -> AppleIdentity? {
        let credential = authorization.credential as? ASAuthorizationAppleIDCredential
        guard let token = credential?.identityToken, let idToken = String(data: token, encoding: .utf8) else {
            return nil
        }
        return AppleIdentity(idToken: idToken, rawNonce: nonce.raw)
    }
}
