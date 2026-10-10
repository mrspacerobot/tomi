import SwiftUI

/// The rows of a question as tick rows. Which are ticked and what a tap does are decided by the caller.
struct ChoiceList: View {
    let choices: [TickChoice]
    let isSelected: (TickChoice) -> Bool
    let onTap: (TickChoice) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(choices) { choice in
                TickRow(name: choice.name, note: choice.note, isSelected: isSelected(choice)) {
                    onTap(choice)
                }
                .accessibilityIdentifier("choice-" + choice.id)
            }
        }
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
