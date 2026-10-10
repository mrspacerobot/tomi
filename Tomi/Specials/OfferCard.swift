import SwiftUI
import TomiCore

/// One dish on offer: its name, time and technique, the server's reason, its swaps and what to buy.
struct OfferCard: View {
    let offer: Offer
    /// The label set into the box of tonight's special, nil for an alternative.
    let flag: LocalizedStringResource?
    let cook: () -> Void

    var body: some View {
        DoubleRuledBox(flag: flag) {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(verbatim: offer.title)
                    .textStyle(titleStyle)
                    .accessibilityIdentifier("offer-title-" + offer.lessonID.rawValue)
                Text(.offerLine(offer.minutes, offer.skill.name, offer.level.name))
                    .textStyle(.description)
                if let reason = offer.reason {
                    Text(verbatim: reason)
                        .textStyle(.body)
                }
                OfferDetails(offer: offer)
                Button(action: cook) { Text(.offerCook) }
                    .buttonStyle(.tomiPrimary)
                    .accessibilityIdentifier("offer-cook-" + offer.lessonID.rawValue)
            }
        }
    }

    private var titleStyle: TextStyle {
        if flag == nil {
            return .dish
        }
        return .title
    }
}
