import SwiftUI

/// Next, or on the last question the button that sends every answer.
struct OnboardingNextButton: View {
    let model: OnboardingModel
    let finish: (Bool) -> Void

    var body: some View {
        if model.isLastQuestion {
            Button {
                finish(false)
            } label: {
                Text(.openingStartShow)
            }
            .buttonStyle(ShowPrimaryButtonStyle())
            .disabled(model.saver.isSaving)
            .accessibilityIdentifier("onboarding-done")
        } else {
            Button(action: model.next) { Text(.onboardingNext) }
                .buttonStyle(ShowPrimaryButtonStyle())
                .accessibilityIdentifier("onboarding-next")
        }
    }
}
