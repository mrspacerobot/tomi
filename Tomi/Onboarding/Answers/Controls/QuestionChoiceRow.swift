import SwiftUI

struct QuestionChoiceRow: View {
    let choice: TickChoice
    let selected: Bool
    let action: () -> Void
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        if showStyle {
            ShowQuestionChoice(choice: choice, selected: selected, action: action)
        } else {
            TickRow(name: choice.name, note: choice.note, isSelected: selected, action: action)
        }
    }
}

#Preview {
    QuestionChoiceRow(choice: TickChoice(optionID: "first", name: "First"), selected: true, action: {})
        .environment(\.usesShowQuestionStyle, true)
}
