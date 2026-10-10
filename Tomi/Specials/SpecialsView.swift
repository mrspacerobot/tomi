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
                AlternativesList(offers: menu.alternatives, path: $path)
            }
            .padding(Spacing.screenMargin)
        }
    }
}
