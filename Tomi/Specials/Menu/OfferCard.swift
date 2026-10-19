import SwiftUI
import TomiCore

/// One dish on offer: its name, technique and level, the server's reason, what the safe plan changes and what
/// was checked. The button opens the plan beside the graph's own recipe.
struct OfferCard: View {
    let offer: Offer
    let options: LibraryOptions
    /// The label set into the box of tonight's special, nil for an alternative.
    let flag: LocalizedStringResource?
    let open: () -> Void

    var body: some View {
        DoubleRuledBox(flag: flag) {
            VStack(alignment: .leading, spacing: Spacing.small) {
                OfferHeading(offer: offer, isSpecial: flag != nil)
                OfferSummary(offer: offer, options: options)
                Button(action: open) { Text(.offerOpen) }
                    .buttonStyle(.tomiPrimary)
                    .accessibilityIdentifier("offer-open-" + offer.recipeID.rawValue)
            }
        }
    }
}
