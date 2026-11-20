import SwiftUI
import TomiCore

/// What became of the typed word: the candidates to pick from, or that Tomi does not know it.
struct TypedItemOutcome: View {
    let typing: TypedItemModel
    let look: TypedItemLook
    let onAdd: (NamedOption) -> Void
    @Environment(\.usesShowQuestionStyle) private var showStyle

    var body: some View {
        if let choosing = typing.choosing {
            Text(.confirmWhichOne(choosing.label))
                .textStyle(outcomeStyle)
            FlowLayout {
                ForEach(choosing.candidates) { candidate in
                    QuestionChip(name: candidate.name, kind: .off) {
                        onAdd(candidate)
                        typing.finishChoosing()
                    }
                    .accessibilityIdentifier(look.identifierPrefix + "-candidate-" + candidate.id.rawValue)
                }
            }
        } else if let unknown = typing.unknownLabel {
            Text(.confirmNotKnown(unknown))
                .textStyle(outcomeStyle)
        } else if let problem = typing.problem {
            ProblemView(problem: problem)
        }
    }

    private var outcomeStyle: TextStyle {
        if showStyle { return .showLede }
        return .description
    }
}
