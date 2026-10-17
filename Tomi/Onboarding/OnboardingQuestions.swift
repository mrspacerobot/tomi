import SwiftUI

/// The question on screen and the buttons that move between them.
struct OnboardingQuestions: View {
    let flow: AppFlowModel
    @State var model: OnboardingModel

    var body: some View {
        content.companionHost(identifier: "onboarding-companion")
    }

    @ViewBuilder private var content: some View {
        if model.showsWelcome {
            OnboardingWelcomeView(start: model.start)
        } else {
            questions
        }
    }

    private var questions: some View {
        VStack(spacing: Spacing.none) {
            OnboardingHeader(completed: model.position, total: model.questions.count, back: model.back)
            ScrollView {
                OnboardingQuestionContent(model: model)
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

#Preview {
    let flow = AppFlowModel.preview()
    let options = FakeServerData(library: BundledLessonLibrary()).options
    OnboardingQuestions(flow: flow, model: OnboardingModel(profile: flow.profile, options: options))
}
