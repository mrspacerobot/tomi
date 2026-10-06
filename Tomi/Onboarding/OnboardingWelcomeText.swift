import SwiftUI

/// The companion, the kicker and the promise on the welcome screen.
struct OnboardingWelcomeText: View {
    var body: some View {
        ScrollView {
            column
        }
        .defaultScrollAnchor(.center, for: .alignment)
        .scrollBounceBehavior(.basedOnSize)
    }

    private var column: some View {
        VStack(spacing: Spacing.large) {
            CompanionSlot(state: .idle, side: MascotSize.companionWelcome)
            Text(.welcomeKicker)
                .textStyle(.label)
            Text(.onboardingWelcomeTitle)
                .textStyle(.displayXL)
                .accessibilityIdentifier("onboarding-welcome-title")
            Text(.onboardingWelcomeBody)
                .textStyle(.body)
        }
    }
}

#Preview {
    OnboardingWelcomeText()
}
