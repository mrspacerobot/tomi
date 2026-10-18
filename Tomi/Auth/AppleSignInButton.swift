import AuthenticationServices
import SwiftUI

/// Apple's own sign-in button. It asks Apple for an identity token bound to a fresh nonce and hands over
/// the token with the raw nonce, for Supabase. Requests email so Supabase Auth can store the contact address.
struct AppleSignInButton: View {
    let onIdentity: (AppleIdentity) -> Void
    let onFailure: () -> Void
    @State private var nonce = AppleNonce.random()
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        SignInWithAppleButton(.signIn, onRequest: prepare, onCompletion: finish)
            .signInWithAppleButtonStyle(style)
            .frame(height: TouchTarget.button)
            .accessibilityIdentifier("sign-in-apple")
    }

    /// Apple's guidelines: a black button on a light ground, a white one on a dark ground.
    private var style: SignInWithAppleButton.Style {
        switch colorScheme {
        case .dark: SignInWithAppleButton.Style.white
        default: SignInWithAppleButton.Style.black
        }
    }

    private func prepare(_ request: ASAuthorizationAppleIDRequest) {
        nonce = AppleNonce.random()
        request.requestedScopes = [.email]
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
