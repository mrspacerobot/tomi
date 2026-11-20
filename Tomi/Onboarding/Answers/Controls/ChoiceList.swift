import SwiftUI

/// The rows of a question as tick rows. Which are ticked and what a tap does are decided by the caller.
struct ChoiceList: View {
    let choices: [TickChoice]
    let isSelected: (TickChoice) -> Bool
    let onTap: (TickChoice) -> Void
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        VStack(spacing: rowGap) {
            ForEach(choices) { choice in
                QuestionChoiceRow(choice: choice, selected: isSelected(choice)) {
                    onTap(choice)
                }
                .accessibilityIdentifier("choice-" + choice.id)
            }
        }
    }

    private var rowGap: CGFloat {
        if showStyle { return ShowSize.gap }
        return Spacing.none
    }
}

#Preview {
    ChoiceList(
        choices: [TickChoice(optionID: "a", name: "First"), TickChoice(optionID: "b", name: "Second", note: "Note")],
        isSelected: { $0.id == "a" },
        onTap: { _ in }
    )
    .background(ColorRole.paper.color)
}
