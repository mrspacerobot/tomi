import SwiftUI

/// The question on screen and the buttons that move between them.
struct OnboardingQuestions: View {
    let flow: AppFlowModel
    @State var model: OnboardingModel

    var body: some View {
        VStack(spacing: Spacing.none) {
            ScrollView {
                QuestionView(question: model.question, draft: model.draft)
                    .padding(Spacing.screenMargin)
            }
            OnboardingFooter(model: model) { confirmed in
                Task { await finish(confirmed: confirmed) }
            }
        }
        .background(ColorRole.paper.color)
    }

    private func finish(confirmed: Bool) async {
        if await model.finish(confirmed: confirmed) {
            flow.finishOnboarding()
        }
    }
}
