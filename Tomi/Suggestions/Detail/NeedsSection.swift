import SwiftUI
import TomiCore

/// What the cook still has to buy, the equipment the recipe asks for and what the dish was checked against.
struct NeedsSection: View {
    let suggestion: Suggestion
    let options: LibraryOptions

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            SuggestionMissingLine(suggestion: suggestion, style: .showText)
            if !suggestion.safePlan.equipment.isEmpty {
                Text(.suggestionEquipment(suggestion.safePlan.equipment.map(\.name).formatted(.list(type: .and))))
                    .textStyle(.showText)
            }
            SuggestionCheckedLine(checked: suggestion.checked, options: options)
        }
    }
}
