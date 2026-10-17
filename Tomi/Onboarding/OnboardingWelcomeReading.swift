import SwiftUI

/// The words of the welcome, laid out as in the mockup when they fit. When the cook's text size makes
/// them taller than the screen, they scroll as one piece, so nothing is squeezed or cut.
struct OnboardingWelcomeReading: View {
    var body: some View {
        ViewThatFits(in: .vertical) {
            OnboardingWelcomeLines(centred: true)
            ScrollView {
                OnboardingWelcomeLines(centred: false)
            }
            .accessibilityIdentifier("onboarding-welcome-reading")
        }
    }
}

#Preview {
    OnboardingWelcomeReading()
}

#Preview("Largest text") {
    OnboardingWelcomeReading()
        .dynamicTypeSize(.accessibility5)
}
