import SwiftUI
import TomiCore

/// The graph's own recipe, word for word. It is never described as adapted: the plan above is what changes.
struct SourceRecipeSection: View {
    let offer: Offer

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            SectionHeading(words: .offerSourceTitle)
            Text(.offerSourceNote)
                .textStyle(.description)
            ForEach(Array(offer.sourceRecipe.ingredients.enumerated()), id: \.offset) { _, line in
                SourceLineRow(offer: offer, line: line)
            }
            ForEach(Array(offer.sourceRecipe.steps.enumerated()), id: \.offset) { position, step in
                SourceStepRow(number: position + 1, step: step)
            }
        }
        .accessibilityIdentifier("offer-source")
    }
}
