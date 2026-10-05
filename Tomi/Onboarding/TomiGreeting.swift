import SwiftUI

/// Tomi with a line he says, at the top of the first question.
struct TomiGreeting: View {
    let words: LocalizedStringResource

    var body: some View {
        HStack(spacing: Spacing.xSmall) {
            TomiMascot()
                .frame(width: MascotSize.greeting, height: MascotSize.greeting)
                .accessibilityHidden(true)
            Text(words)
                .textStyle(.description)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, Spacing.screenMargin)
    }
}

#Preview {
    TomiGreeting(words: .onboardingDietGreeting)
        .background(ColorRole.paper.color)
}
