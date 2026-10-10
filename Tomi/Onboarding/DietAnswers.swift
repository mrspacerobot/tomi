import SwiftUI
import TomiCore

/// One diet, or none: "I eat everything" is the app's own row, the diets are the server's.
struct DietAnswers: View {
    let draft: AnswersDraft

    var body: some View {
        ChoiceList(choices: choices, isSelected: { $0.optionID == draft.answers.diet }) { choice in
            draft.answers.diet = choice.optionID
        }
    }

    private var choices: [TickChoice] {
        let none = TickChoice(optionID: nil, name: String(localized: .questionDietNone))
        let diets = draft.options.diets.map { TickChoice(optionID: $0.id, name: $0.name, note: $0.summary) }
        return [none] + diets
    }
}

#Preview {
    DietAnswers(draft: .preview())
        .background(ColorRole.paper.color)
}
