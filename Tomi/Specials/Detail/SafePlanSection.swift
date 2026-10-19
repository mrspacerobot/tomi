import SwiftUI
import TomiCore

/// The plan for this cook: the ingredients after the server's changes, the changes themselves, what to buy,
/// what to have in the kitchen and what the plan was checked against.
struct SafePlanSection: View {
    let offer: Offer
    let options: LibraryOptions

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            SectionHeading(words: .offerPlanTitle)
            ForEach(offer.safePlan.ingredients) { ingredient in
                AmountRow(name: ingredient.name, amount: amount(of: ingredient))
            }
            SafePlanChanges(offer: offer)
            SafePlanNeeds(offer: offer)
            OfferCheckedLine(checked: offer.checked, options: options)
        }
        .accessibilityIdentifier("offer-plan")
    }

    /// The amount the graph's recipe gives for an ingredient the plan keeps as it is. A stand-in has none here:
    /// scaling a swap is the server's job, which it does not do yet.
    private func amount(of ingredient: NamedOption) -> String? {
        let line = offer.sourceRecipe.ingredients.first { $0.thing == ingredient.id }
        guard let amount = line?.amount else {
            return nil
        }
        return SourceAmountFormat.text(for: amount)
    }
}
