import SwiftUI

/// Everything on the welcome above its button: the promise, then the line that says how long it takes.
/// Centred, the promise sits in the middle and the line rests on the button, as in the mockup.
struct OnboardingWelcomeLines: View {
    let centred: Bool

    var body: some View {
        VStack(spacing: Spacing.large) {
            if centred {
                Spacer()
            }
            OnboardingWelcomeText()
            if centred {
                Spacer()
            }
            Text(.onboardingWelcomeHint)
                .textStyle(.description)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    OnboardingWelcomeLines(centred: true)
}
