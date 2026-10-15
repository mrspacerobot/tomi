import SwiftUI

/// The cook avoids nothing. Ticked while nothing else is; tapping it clears every other tick.
struct NoneOfTheseRow: View {
    let draft: AnswersDraft

    var body: some View {
        TickRow(name: String(localized: .questionAvoidNone), isSelected: draft.answers.avoid.isEmpty) {
            draft.answers.avoid = []
        }
        .accessibilityIdentifier("avoid-none")
    }
}

#Preview {
    NoneOfTheseRow(draft: .preview())
        .background(ColorRole.paper.color)
}
