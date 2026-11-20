import SwiftUI

/// One question about the cook: its title, its hint and its answers.
struct QuestionView: View {
    let question: ProfileQuestion
    let draft: AnswersDraft

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(question.title)
                .textStyle(.showTitle)
                .accessibilityIdentifier(question.identifier)
            Text(question.hint)
                .textStyle(.showLede)
            QuestionAnswers(question: question, draft: draft)
        }
    }
}

#Preview {
    ScrollView {
        QuestionView(question: .kitchen, draft: .preview())
            .padding(Spacing.screenMargin)
    }
    .background { ShowStage() }
}
