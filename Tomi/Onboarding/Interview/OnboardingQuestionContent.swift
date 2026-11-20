import SwiftUI

struct OnboardingQuestionContent: View {
    let model: OnboardingModel

    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.rowGap) {
            TomiGreeting(question: model.question)
            QuestionAnswers(question: model.question, draft: model.draft)
            Text(model.question.hint).textStyle(.showLede, color: .stageMuted)
        }
    }
}

#Preview {
    let flow = AppFlowModel.preview()
    OnboardingQuestionContent(model: OnboardingModel(profile: flow.profile, options: FakeServerData().options))
        .environment(\.usesShowQuestionStyle, true)
        .background { ShowStage() }
}
