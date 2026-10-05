import SwiftUI
import TomiCore

/// Under the avoid list: what has been ticked so far, and the Continue button, off until there is an answer.
struct OnboardingAvoidFooter: View {
    let avoidedNames: [String]
    let canContinue: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: Spacing.small) {
            if !avoidedNames.isEmpty {
                Text(.onboardingAvoidSummary(avoidedNames.formatted(.list(type: .and))))
                    .textStyle(.description)
            }
            Button(action: action) {
                Text(.onboardingContinue)
            }
            .buttonStyle(.tomiPrimary)
            .disabled(!canContinue)
            .accessibilityIdentifier("onboarding-continue")
        }
        .padding(Spacing.screenMargin)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    OnboardingAvoidFooter(avoidedNames: ["Nuts", "Shellfish"], canContinue: true, action: {})
}
