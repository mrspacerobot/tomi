import SwiftUI
import TomiCore

/// What the cook still has to buy for the dish, when there is anything.
struct OfferMissingLine: View {
    let offer: Offer
    let style: TextStyle

    var body: some View {
        if !offer.safePlan.missing.isEmpty {
            Text(.offerMissing(offer.safePlan.missing.map(\.name).formatted(.list(type: .and))))
                .textStyle(style)
                .accessibilityIdentifier("offer-missing")
        }
    }
}
