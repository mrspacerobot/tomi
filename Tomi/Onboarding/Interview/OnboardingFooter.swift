import SwiftUI

/// Back and next, or done on the last question, with any problem saving and the confirmation it may need.
struct OnboardingFooter: View {
    let model: OnboardingModel
    let finish: (Bool) -> Void

    var body: some View {
        VStack(spacing: Spacing.small) {
            if let problem = model.saver.problem {
                ProblemView(problem: problem)
            }
            OnboardingButtons(model: model, finish: finish)
        }
        .padding(ShowSize.controlEdge)
        .confirmRestrictionRemoval(isPresented: confirming) { finish(true) }
    }

    private var confirming: Binding<Bool> {
        Binding(get: { model.saver.isConfirming }, set: { model.saver.isConfirming = $0 })
    }
}
