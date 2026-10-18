import SwiftUI
import TomiCore

/// One ingredient line of the graph's recipe, with a plain note when the plan swaps it or leaves it out.
struct SourceLineRow: View {
    let offer: Offer
    let line: SourceLine

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            AmountRow(name: offer.name(ofSourceIngredient: line.thing), amount: amount)
            if let swap = offer.substitution(for: line) {
                Text(.offerSourceSwapped(swap.added.name))
                    .textStyle(.caption)
            }
            if offer.omits(line) {
                Text(.offerSourceOmitted)
                    .textStyle(.caption)
            }
        }
    }

    private var amount: String? {
        guard let amount = line.amount else {
            return nil
        }
        return SourceAmountFormat.text(for: amount)
    }
}
