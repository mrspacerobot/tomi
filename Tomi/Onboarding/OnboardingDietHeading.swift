import SwiftUI

/// The kicker, title and subtitle of the diet question.
struct OnboardingDietHeading: View {
    var body: some View {
        OnboardingQuestionHeading(
            question: 1,
            title: .onboardingDietTitle,
            subtitle: .onboardingDietSubtitle,
            titleIdentifier: "onboarding-diet-title"
        )
        .padding(.horizontal, Spacing.screenMargin)
    }
}

#Preview {
    OnboardingDietHeading()
        .background(ColorRole.paper.color)
}
