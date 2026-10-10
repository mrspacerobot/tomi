import SwiftUI
import TomiCore

/// Tonight's special and up to two alternatives, each only shown when the server checked it for this cook.
struct SpecialsView: View {
    let menu: TonightsMenu
    @Binding var path: [HomeRoute]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                if let special = menu.special {
                    OfferCard(offer: special, flag: .specialsKicker) { path.append(.cook(special)) }
                }
                if !menu.alternatives.isEmpty {
                    Text(.specialsAlternatives)
                        .textStyle(.label)
                        .textCase(.uppercase)
                    ForEach(menu.alternatives) { offer in
                        OfferCard(offer: offer, flag: nil) { path.append(.cook(offer)) }
                    }
                }
            }
            .padding(Spacing.screenMargin)
        }
    }
}
