import SwiftUI

struct EmailAddressField: View {
    @Binding var email: String
    var editing: FocusState<EmailAuthField?>.Binding

    var body: some View {
        ShowEmailField(title: .authEmailPrompt) {
            TextField(text: $email) { Text(.authEmailPrompt) }
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused(editing, equals: .email)
                .accessibilityIdentifier("auth-email")
        }
    }
}

#Preview {
    @Previewable @FocusState var editing: EmailAuthField?
    EmailAddressField(email: .constant("cook@example.com"), editing: $editing)
}
