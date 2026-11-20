import SwiftUI

/// Links between sign-in, account creation and password recovery.
struct EmailAuthModeActions: View {
    @Bindable var model: EmailAuthModel

    var body: some View {
        VStack(spacing: Spacing.xSmall) {
            if model.mode == .signIn {
                recoveryButton
                createAccountButton
            } else {
                backButton
            }
        }
    }

    private var recoveryButton: some View {
        Button(.authForgotPassword) { model.choose(.passwordRecovery) }
            .buttonStyle(EmailAuthLinkStyle())
            .accessibilityIdentifier("auth-forgot-password")
    }

    private var createAccountButton: some View {
        Button(.authCreateAccount) { model.choose(.createAccount) }
            .buttonStyle(EmailAuthLinkStyle())
            .accessibilityIdentifier("auth-create-account")
    }

    private var backButton: some View {
        Button(.authBackToSignIn) { model.choose(.signIn) }
            .buttonStyle(EmailAuthLinkStyle())
            .accessibilityIdentifier("auth-back-to-sign-in")
    }
}

#Preview {
    EmailAuthModeActions(model: EmailAuthModel(flow: .preview()))
        .padding()
        .background { ShowStage() }
}
