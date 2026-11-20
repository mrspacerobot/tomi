import SwiftUI

/// The cook avoids nothing. Ticked while nothing else is; tapping it clears every other tick.
struct NoneOfTheseRow: View {
    let draft: AnswersDraft

    var body: some View {
        ShowQuestionChoice(choice: choice, selected: draft.answers.avoid.isEmpty) {
            draft.answers.avoid = []
        }
        .accessibilityIdentifier("avoid-none")
    }

    private var choice: TickChoice {
        TickChoice(optionID: nil, name: String(localized: .questionAvoidNone))
    }
}

#Preview {
    NoneOfTheseRow(draft: .preview())
        .background { ShowStage() }
}
