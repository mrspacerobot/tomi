import SwiftUI

/// The mascot, the kicker and the promise on the welcome screen.
struct OnboardingWelcomeText: View {
    var body: some View {
        VStack(spacing: Spacing.large) {
            TomiMascot()
                .frame(width: MascotSize.welcome, height: MascotSize.welcome)
                .accessibilityHidden(true)
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
