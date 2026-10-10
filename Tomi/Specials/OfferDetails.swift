import SwiftUI
import TomiCore

/// The swaps the server applied and what the cook still needs to buy.
struct OfferDetails: View {
    let offer: Offer

    var body: some View {
        ForEach(offer.swaps, id: \.self) { swap in
            Text(.offerSwap(swap.added.name, swap.removed.name))
                .textStyle(.description)
        }
        if !offer.missing.isEmpty {
            Text(.offerMissing(missingNames))
                .textStyle(.description)
                .accessibilityIdentifier("offer-missing")
        }
    }

    private var missingNames: String {
        offer.missing.map(\.name).formatted(.list(type: .and))
    }
}
