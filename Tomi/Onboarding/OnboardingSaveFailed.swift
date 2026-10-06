import SwiftUI

/// Tomi's words when the answers could not be saved.
struct OnboardingSaveFailed: View {
    var body: some View {
        Text(.onboardingSaveFailed)
            .textStyle(.description, color: .stampRed)
            .padding(Spacing.screenMargin)
            .accessibilityIdentifier("onboarding-save-failed")
    }
}

#Preview {
    OnboardingSaveFailed()
}
