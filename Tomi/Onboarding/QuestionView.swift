import SwiftUI

/// One question about the cook: its title, its hint and its answers.
struct QuestionView: View {
    let question: ProfileQuestion
    let draft: AnswersDraft
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(question.title)
                .textStyle(titleStyle)
                .accessibilityIdentifier(question.identifier)
            Text(question.hint)
                .textStyle(hintStyle)
            QuestionAnswers(question: question, draft: draft)
        }
    }

    private var titleStyle: TextStyle {
        if showStyle { return .showTitle }
        return .displayL
    }

    private var hintStyle: TextStyle {
        if showStyle { return .showLede }
        return .description
    }
}

#Preview {
    ScrollView {
        QuestionView(question: .kitchen, draft: .preview())
            .padding(Spacing.screenMargin)
    }
    .background(ColorRole.paper.color)
}
