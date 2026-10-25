import SwiftUI

/// Tomi with a line he says, at the top of the first question.
struct TomiGreeting: View {
    let words: LocalizedStringResource
    @Environment(\.dynamicTypeSize) private var textSize

    var body: some View {
        layout {
            CompanionSlot(state: .explaining, side: MascotSize.companionGreeting)
            Text(words)
                .textStyle(.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityIdentifier("onboarding-greeting")
        }
    }

    private var layout: AnyLayout {
        if textSize.isAccessibilitySize {
            return AnyLayout(VStackLayout(alignment: .leading, spacing: Spacing.xSmall))
        }
        return AnyLayout(HStackLayout(spacing: Spacing.xSmall))
    }
}

#Preview {
    TomiGreeting(words: .onboardingDietGreeting)
        .background(ColorRole.paper.color)
}
