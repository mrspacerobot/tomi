import SwiftUI

/// Meet Tomi and start the profile interview.
struct OnboardingWelcomeView: View {
    let start: () -> Void

    var body: some View {
        OnboardingWelcomeReading(start: start)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { ShowStage() }
    }
}

#Preview("Morning") { OnboardingWelcomeView(start: {}).preferredColorScheme(.light) }
#Preview("Evening, largest text") {
    OnboardingWelcomeView(start: {}).preferredColorScheme(.dark).dynamicTypeSize(.accessibility5)
}
