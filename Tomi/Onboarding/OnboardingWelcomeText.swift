import SwiftUI

/// The companion, the kicker and the promise on the welcome screen.
struct OnboardingWelcomeText: View {
    var body: some View {
        VStack(spacing: Spacing.large) {
            OnboardingWelcomeTomi()
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
