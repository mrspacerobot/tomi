import SwiftUI
import TomiCore

/// People at the table most nights, one or more.
struct ServingsStepper: View {
    static let mostServings = 12

    let draft: AnswersDraft

    var body: some View {
        Stepper(value: servings, in: CookProfile.minimumServings...Self.mostServings) {
            Text(.questionTableServings(draft.answers.servings))
                .textStyle(.body)
        }
        .accessibilityIdentifier("servings")
    }

    private var servings: Binding<Int> {
        Binding(
            get: { draft.answers.servings },
            set: { draft.answers.setServings($0) }
        )
    }
}

#Preview {
    ServingsStepper(draft: .preview())
        .padding()
}
