import SwiftUI
import TomiCore

/// The swaps and left-out parts of the plan, each with the server's caveat and ratio.
struct SafePlanChanges: View {
    let offer: Offer

    var body: some View {
        ForEach(offer.safePlan.substitutions, id: \.id) { swap in
            SafePlanSwapRow(swap: swap)
        }
        OfferOmittedLine(offer: offer, style: .body)
    }
}
