import SwiftUI
import TomiCore

/// What the safe plan changes for this cook, what to buy, and what the server checked the dish against.
/// This is the menu's short form of the plan; the detail screen has all of it.
struct OfferSummary: View {
    let offer: Offer
    let options: LibraryOptions

    var body: some View {
        ForEach(offer.safePlan.substitutions, id: \.added.id) { swap in
            Text(.offerSwap(swap.added.name, swap.removed.name))
                .textStyle(.description)
        }
        OfferOmittedLine(offer: offer, style: .description)
        OfferMissingLine(offer: offer, style: .description)
        OfferCheckedLine(checked: offer.checked, options: options)
    }
}
