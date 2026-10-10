import SwiftUI

/// Back, when there is a question before, and next or done.
struct OnboardingButtons: View {
    let model: OnboardingModel
    let finish: (Bool) -> Void

    var body: some View {
        HStack(spacing: Spacing.small) {
            if model.canGoBack {
                Button(action: model.back) { Text(.onboardingBack) }
                    .buttonStyle(.tomiSecondary)
                    .accessibilityIdentifier("onboarding-back")
            }
            OnboardingNextButton(model: model, finish: finish)
        }
    }
}
