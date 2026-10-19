import SwiftUI
import TomiCore

/// What the cook still has to buy and the equipment the recipe asks for.
struct SafePlanNeeds: View {
    let suggestion: Suggestion

    var body: some View {
        SuggestionMissingLine(suggestion: suggestion, style: .body)
        if !suggestion.safePlan.equipment.isEmpty {
            Text(.suggestionEquipment(suggestion.safePlan.equipment.map(\.name).formatted(.list(type: .and))))
                .textStyle(.body)
        }
    }
}
