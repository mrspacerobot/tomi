import SwiftUI

/// One question, opened from settings, with the cook's current answers and a button that saves them.
struct SettingsQuestionView: View {
    let question: ProfileQuestion
    let flow: AppFlowModel

    var body: some View {
        if let options = flow.profile.options {
            SettingsQuestionForm(
                question: question,
                draft: AnswersDraft(answers: flow.profile.profile, options: options),
                saver: AnswersSaver(profile: flow.profile)
            )
        } else {
            LoadFailedView(flow: flow)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsQuestionView(question: .avoid, flow: .preview())
    }
}
