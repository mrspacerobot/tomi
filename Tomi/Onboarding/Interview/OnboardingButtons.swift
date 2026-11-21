import SwiftUI

/// Next or done. Back stays in the shared question header.
struct OnboardingButtons: View {
    let model: OnboardingModel
    let finish: (Bool) -> Void

    var body: some View {
        OnboardingNextButton(model: model, finish: finish)
    }
}
