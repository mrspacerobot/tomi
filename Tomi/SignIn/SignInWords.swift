import SwiftUI

/// The title and the line that says why Tomi asks the cook to sign in.
struct SignInWords: View {
    var body: some View {
        VStack(spacing: Spacing.small) {
            Text(.welcomeTitle)
                .textStyle(.displayXL)
                .accessibilityIdentifier("sign-in-title")
            Text(.signInMessage)
                .textStyle(.description)
        }
    }
}

#Preview {
    SignInWords()
}
