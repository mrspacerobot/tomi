import SwiftUI

struct EmailPasswordField: View {
    @Binding var password: String
    var editing: FocusState<EmailAuthField?>.Binding
    let failed: Bool

    var body: some View {
        ShowEmailField(title: .authPasswordPrompt, failed: failed) {
            SecureField(text: $password) { Text(.authPasswordPrompt) }
                .textContentType(.password)
                .focused(editing, equals: .password)
                .accessibilityIdentifier("auth-password")
        }
    }
}

#Preview {
    @Previewable @FocusState var editing: EmailAuthField?
    EmailPasswordField(password: .constant("test"), editing: $editing, failed: true)
}
