import SwiftUI

/// A shared companion stays with the cook while the answers come from the server.
struct OnboardingQuestionContent: View {
    let model: OnboardingModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            if model.question == .diet {
                TomiGreeting(words: .onboardingDietGreeting)
            } else {
                CompanionSlot(state: .idle, side: MascotSize.companionGreeting)
            }
            QuestionView(question: model.question, draft: model.draft)
        }
    }
}

#Preview {
    let flow = AppFlowModel.preview()
    if let options = flow.profile.options {
        OnboardingQuestionContent(model: OnboardingModel(profile: flow.profile, options: options))
    }
}
