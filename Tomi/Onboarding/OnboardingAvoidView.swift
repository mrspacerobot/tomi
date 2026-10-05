import SwiftUI
import TomiCore

/// "Anything to avoid?": tick all that apply, or say "None of these". Continue waits for one of the two.
struct OnboardingAvoidView: View {
    let items: [AvoidItem]
    let answer: AvoidAnswer
    let tap: (AvoidItemID) -> Void
    let tapNone: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            OnboardingQuestionHeading(
                question: 2,
                title: .onboardingAvoidTitle,
                subtitle: .onboardingAvoidSubtitle,
                titleIdentifier: "onboarding-avoid-title"
            )
            AvoidGrid(items: items, answer: answer, tap: tap)
            AvoidCell(name: String(localized: .onboardingAvoidNone), isSelected: answer.isNoneTicked, action: tapNone)
                .accessibilityIdentifier("onboarding-avoid-none")
            AvoidNote()
        }
        .padding(.horizontal, Spacing.screenMargin)
    }
}
