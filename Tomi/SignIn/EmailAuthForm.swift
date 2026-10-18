import SwiftUI

/// Email and password fields with the action and mode changes below them.
struct EmailAuthForm: View {
    @Bindable var model: EmailAuthModel

    var body: some View {
        VStack(spacing: Spacing.medium) {
            EmailAuthFields(model: model)
            if let notice = model.notice {
                Text(notice)
                    .textStyle(.body)
                    .accessibilityIdentifier(noticeIdentifier)
            }
            submitButton
            EmailAuthModeActions(model: model)
        }
    }

    private var submitButton: some View {
        Button {
            Task { await model.submit() }
        } label: {
            Text(model.mode.submitTitle)
        }
        .buttonStyle(.tomiPrimary)
        .disabled(!model.canSubmit)
        .accessibilityIdentifier(submitIdentifier)
    }

    private var submitIdentifier: String {
        switch model.mode {
        case .signIn: "auth-sign-in"
        case .createAccount: "auth-create-submit"
        case .passwordRecovery: "auth-reset-submit"
        }
    }

    private var noticeIdentifier: String {
        switch model.mode {
        case .signIn: "auth-sign-in-message"
        case .createAccount: "auth-confirmation-message"
        case .passwordRecovery: "auth-recovery-message"
        }
    }
}

#Preview {
    EmailAuthForm(model: EmailAuthModel(flow: .preview()))
        .padding()
        .background(ColorRole.paper.color)
}
