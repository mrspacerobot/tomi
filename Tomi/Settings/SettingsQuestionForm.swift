import SwiftUI

/// The question, any problem saving, and the save button with the confirmation a removal needs.
struct SettingsQuestionForm: View {
    let question: ProfileQuestion
    @State var draft: AnswersDraft
    @State var saver: AnswersSaver
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                SettingsEditHeader(back: { dismiss() })
                QuestionView(question: question, draft: draft)
                if let problem = saver.problem {
                    ProblemView(problem: problem)
                }
                SaveAnswersButton(saver: saver) { save(confirmed: false) }
            }
            .padding(ShowSize.edge)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .background { ShowStage() }
        .environment(\.usesShowQuestionStyle, true)
        .confirmRestrictionRemoval(isPresented: $saver.isConfirming) { save(confirmed: true) }
    }

    private func save(confirmed: Bool) {
        Task {
            if await saver.save(draft.answers, confirmed: confirmed) {
                dismiss()
            }
        }
    }
}
