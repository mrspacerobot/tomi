import SwiftUI
import TomiCore

/// The parts of the dish the safe plan leaves out, when it leaves any out.
struct OfferOmittedLine: View {
    let offer: Offer
    let style: TextStyle

    var body: some View {
        if !offer.safePlan.omittedParts.isEmpty {
            Text(.offerOmitted(offer.omittedNames.formatted(.list(type: .and))))
                .textStyle(style)
                .accessibilityIdentifier("offer-omitted")
        }
    }
}
