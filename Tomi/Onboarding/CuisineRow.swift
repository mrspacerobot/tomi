import SwiftUI
import TomiCore

/// One cuisine and its three answers as chips. The chosen answer is ticked; the others carry a plus.
struct CuisineRow: View {
    let cuisine: NamedOption
    let draft: AnswersDraft
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(verbatim: cuisine.name)
                .textStyle(titleStyle)
            FlowLayout {
                ForEach(CuisineAnswer.allCases, id: \.self) { answer in
                    QuestionChip(name: String(localized: answer.words), kind: kind(of: answer)) {
                        draft.answers.setAnswer(answer, for: cuisine.id)
                    }
                    .accessibilityIdentifier("cuisine-" + cuisine.id.rawValue + "-" + String(describing: answer))
                }
            }
        }
    }

    private var titleStyle: TextStyle {
        if showStyle { return .showTitle }
        return .option
    }

    private func kind(of answer: CuisineAnswer) -> ChipKind {
        if draft.answers.answer(for: cuisine.id) == answer {
            return .on
        }
        return .off
    }
}

#Preview {
    CuisineRow(cuisine: NamedOption(id: "thai", name: "Thai"), draft: .preview())
        .padding()
        .background(ColorRole.paper.color)
}
