import SwiftUI
import TomiCore

/// A dish on offer in full: the safe plan for this cook, then the graph's own recipe beside it, unchanged.
/// Cooking a graph recipe step by step is not built yet; the owner decides how it should look first (#135).
struct OfferDetailView: View {
    let offer: Offer
    let options: LibraryOptions

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                VStack(alignment: .leading, spacing: Spacing.small) {
                    OfferHeading(offer: offer, isSpecial: true)
                }
                SafePlanSection(offer: offer, options: options)
                SourceRecipeSection(offer: offer)
            }
            .padding(Spacing.screenMargin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
        .accessibilityIdentifier("offer-detail")
    }
}
