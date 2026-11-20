import SwiftUI

struct SignInChoiceWords: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(.openingEmailTitle)
                .textStyle(.showLede, color: .stageMuted)
                .frame(minHeight: TouchTarget.minimum)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("open-email-auth")
    }
}

#Preview { SignInChoiceWords(action: {}).background { ShowStage() } }
