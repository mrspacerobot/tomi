import SwiftUI
import TomiCore

/// People at the table most nights, one or more.
struct ServingsStepper: View {
    static let mostServings = 12

    let draft: AnswersDraft
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        QuestionStepperCard {
            Stepper(value: servings, in: CookProfile.minimumServings...Self.mostServings) {
                Text(.questionTableServings(draft.answers.servings))
                    .textStyle(captionStyle)
            }
            .accessibilityIdentifier("servings")
        }
    }

    private var captionStyle: TextStyle {
        if showStyle { return .showBodyStrong }
        return .body
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
