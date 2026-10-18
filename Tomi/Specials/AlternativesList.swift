import SwiftUI
import TomiCore

/// The other dishes the cook could make tonight, under their heading.
struct AlternativesList: View {
    let offers: [Offer]
    let options: LibraryOptions
    @Binding var path: [HomeRoute]

    var body: some View {
        if !offers.isEmpty {
            Text(.specialsAlternatives)
                .textStyle(.label)
                .textCase(.uppercase)
            ForEach(offers) { offer in
                OfferCard(offer: offer, options: options, flag: nil) { path.append(.offer(offer)) }
            }
        }
    }
}
