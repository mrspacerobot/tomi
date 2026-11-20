import SwiftUI

struct ShowQuestionChoice: View {
    let choice: TickChoice
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ShowCard {
                ShowQuestionChoiceLabel(choice: choice, selected: selected)
            }
            .overlay {
                RoundedRectangle(cornerRadius: Radius.showCard).strokeBorder(ring, lineWidth: RuleWeight.showRing)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilitySelected(selected)
        .showFeedback(.selection, trigger: selected)
    }

    private var ring: Color {
        if selected { return ColorRole.showAccent.color }
        return .clear
    }
}

#Preview {
    ShowQuestionChoice(choice: TickChoice(optionID: "first", name: "First"), selected: true, action: {})
        .padding().background { ShowStage() }
}
