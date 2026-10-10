import SwiftUI

/// What became of the typed word: the candidates to pick from, or that Tomi does not know it.
struct TypedItemOutcome: View {
    let typing: TypedItemModel
    let model: ScanModel

    var body: some View {
        if let choosing = typing.choosing {
            Text(.confirmWhichOne(choosing.label))
                .textStyle(.description)
            FlowLayout {
                ForEach(choosing.candidates) { candidate in
                    Chip(name: candidate.name, kind: .off) {
                        model.list.add(candidate)
                        typing.finishChoosing()
                    }
                    .accessibilityIdentifier("confirm-candidate-" + candidate.id.rawValue)
                }
            }
        } else if let unknown = typing.unknownLabel {
            Text(.confirmNotKnown(unknown))
                .textStyle(.description)
        } else if let problem = typing.problem {
            ProblemView(problem: problem)
        }
    }
}
