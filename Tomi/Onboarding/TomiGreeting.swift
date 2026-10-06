import SwiftUI

/// Tomi with a line he says, at the top of the first question.
struct TomiGreeting: View {
    let words: LocalizedStringResource

    var body: some View {
        HStack(spacing: Spacing.xSmall) {
            CompanionSlot(state: .explaining, side: MascotSize.companionGreeting)
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
