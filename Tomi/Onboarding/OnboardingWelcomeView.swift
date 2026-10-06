import SwiftUI

/// The first thing a new cook sees: one promise and one button.
struct OnboardingWelcomeView: View {
    let start: () -> Void

    var body: some View {
        VStack(spacing: Spacing.large) {
            OnboardingWelcomeReading()
            Button(action: start) {
                Text(.onboardingWelcomeStart)
            }
            .buttonStyle(.tomiPrimary)
            .accessibilityIdentifier("onboarding-start")
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.screenMargin)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    OnboardingWelcomeView(start: {})
}

#Preview("Dark, largest text") {
    OnboardingWelcomeView(start: {})
        .preferredColorScheme(.dark)
        .dynamicTypeSize(.accessibility5)
}
