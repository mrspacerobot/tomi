import SwiftUI
import TomiCore

/// What the cook always has at home, as chips: on when it is a staple, off when it is not.
struct CupboardAnswers: View {
    let draft: AnswersDraft

    var body: some View {
        FlowLayout {
            ForEach(draft.options.ingredients) { ingredient in
                Chip(name: ingredient.name, kind: kind(of: ingredient.id)) {
                    draft.answers.toggleCupboardStaple(ingredient.id)
                }
                .accessibilityIdentifier("cupboard-" + ingredient.id.rawValue)
            }
        }
    }

    private func kind(of ingredient: OptionID) -> ChipKind {
        if draft.answers.cupboardStaples.contains(ingredient) {
            return .on
        }
        return .off
    }
}

#Preview {
    CupboardAnswers(draft: .preview())
        .padding()
        .background(ColorRole.paper.color)
}
