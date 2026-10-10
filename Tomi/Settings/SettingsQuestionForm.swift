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
                QuestionView(question: question, draft: draft)
                if let problem = saver.problem {
                    ProblemView(problem: problem)
                }
                Button { save(confirmed: false) } label: { Text(.settingsSave) }
                    .buttonStyle(.tomiPrimary)
                    .disabled(saver.isSaving)
                    .accessibilityIdentifier("settings-save")
            }
            .padding(Spacing.screenMargin)
        }
        .background(ColorRole.paper.color)
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
