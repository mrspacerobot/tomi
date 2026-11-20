import SwiftUI

/// Apple's sign-in button, or in a UI test launch a plain button that signs in to the fake.
struct SignInButton: View {
    let flow: AppFlowModel
    @State private var appleFailed = false

    var body: some View {
        if flow.services.usesFakeSignInButton {
            Button {
                signIn(with: AppleIdentity(idToken: "", rawNonce: ""))
            } label: {
                Text(.signInFake)
            }
            .buttonStyle(ShowPrimaryButtonStyle())
            .accessibilityIdentifier("sign-in-fake")
        } else {
            AppleSignInButton(onIdentity: signIn, onFailure: { appleFailed = true })
            if appleFailed {
                Text(.signInAppleFailed)
                    .textStyle(.showLede)
            }
        }
    }

    private func signIn(with identity: AppleIdentity) {
        Task { await flow.signIn(with: identity) }
    }
}

#Preview {
    SignInButton(flow: .preview())
}
