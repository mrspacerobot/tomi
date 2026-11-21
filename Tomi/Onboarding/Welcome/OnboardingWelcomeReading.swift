import SwiftUI

struct OnboardingWelcomeReading: View {
    let start: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: ShowSize.rowGap) {
                OnboardingWelcomeTomi()
                OnboardingWelcomeLines(start: start)
            }
            .padding(.bottom, ShowSize.footer)
        }
        .accessibilityIdentifier("onboarding-welcome-reading")
    }
}

#Preview { OnboardingWelcomeReading(start: {}).background { ShowStage() } }
