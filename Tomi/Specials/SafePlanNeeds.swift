import SwiftUI
import TomiCore

/// What the cook still has to buy and the equipment the recipe asks for.
struct SafePlanNeeds: View {
    let offer: Offer

    var body: some View {
        OfferMissingLine(offer: offer, style: .body)
        if !offer.safePlan.equipment.isEmpty {
            Text(.offerEquipment(offer.safePlan.equipment.map(\.name).formatted(.list(type: .and))))
                .textStyle(.body)
        }
    }
}
