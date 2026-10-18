import SwiftUI

/// The address field and the password field when the current task needs one.
struct EmailAuthFields: View {
    @Bindable var model: EmailAuthModel

    var body: some View {
        VStack(spacing: Spacing.small) {
            emailField
            if model.mode != .passwordRecovery {
                passwordField
            }
        }
    }

    private var emailField: some View {
        TextField(text: $model.email, prompt: Text(.authEmailPrompt)) { Text(.authEmailPrompt) }
            .textStyle(.body)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .multilineTextAlignment(.leading)
            .padding(Spacing.medium)
            .frame(minHeight: TouchTarget.button)
            .background(ColorRole.wash.color)
            .clipShape(.rect(cornerRadius: Radius.chip))
            .accessibilityIdentifier("auth-email")
    }

    private var passwordField: some View {
        SecureField(text: $model.password, prompt: Text(.authPasswordPrompt)) { Text(.authPasswordPrompt) }
            .textStyle(.body)
            .textContentType(.password)
            .multilineTextAlignment(.leading)
            .padding(Spacing.medium)
            .frame(minHeight: TouchTarget.button)
            .background(ColorRole.wash.color)
            .clipShape(.rect(cornerRadius: Radius.chip))
            .accessibilityIdentifier("auth-password")
    }
}

#Preview {
    EmailAuthFields(model: EmailAuthModel(flow: .preview()))
        .padding()
        .background(ColorRole.paper.color)
}
