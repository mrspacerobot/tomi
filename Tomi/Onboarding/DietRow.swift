import SwiftUI
import TomiCore

/// One answer to the diet question, from the ingredient table.
struct DietRow: View {
    let diet: Diet
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        TickRow(name: diet.name.forCook, note: diet.summary.forCook, isSelected: isSelected, action: action)
            .accessibilityIdentifier("onboarding-diet-\(diet.id.rawValue)")
    }
}
