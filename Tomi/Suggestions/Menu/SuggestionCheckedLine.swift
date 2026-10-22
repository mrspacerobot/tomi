import SwiftUI
import TomiCore

/// The diet and avoid items the server checked the dish against, named from the server's own lists.
struct SuggestionCheckedLine: View {
    let checked: CheckedRestrictions
    let options: LibraryOptions

    var body: some View {
        let names = options.names(checkedFor: checked)
        Group {
            if names.isEmpty {
                Text(.suggestionCheckedNothing)
            } else {
                Text(.suggestionChecked(names.formatted(.list(type: .and))))
            }
        }
        .textStyle(.caption)
        .accessibilityIdentifier("suggestion-checked")
    }
}
