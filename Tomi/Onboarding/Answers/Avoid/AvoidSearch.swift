import SwiftUI
import TomiCore

/// New restrictions must be entries the server already knows how to check.
struct AvoidSearch: View {
    let draft: AnswersDraft
    @State private var query = ""
    @FocusState private var editing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: ShowSize.gap) {
            ShowCard {
                TextField(text: $query) { Text(.openingAvoidSearch) }
                    .textStyle(.showBody)
                    .frame(minHeight: TouchTarget.minimum)
                    .contentShape(.interaction, Rectangle())
                    .focused($editing)
                    .accessibilityIdentifier("avoid-search")
            }
            AvoidSearchResults(query: query, options: draft.options, add: add)
        }
    }

    private func add(_ option: AvoidOption) {
        draft.answers.avoid.insert(option.id)
        query = ""
        editing = false
    }

}

#Preview { AvoidSearch(draft: .preview()).padding().background { ShowStage() } }
