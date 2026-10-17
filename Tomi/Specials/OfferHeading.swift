import SwiftUI
import TomiCore

/// The dish's name, its time and technique, and the server's reason for it, all in the server's words.
struct OfferHeading: View {
    let offer: Offer
    let isSpecial: Bool

    var body: some View {
        Text(verbatim: offer.title)
            .textStyle(titleStyle)
            .accessibilityIdentifier("offer-title-" + offer.lessonID.rawValue)
        Text(.offerLine(offer.minutes, offer.skill.name, offer.level.name))
            .textStyle(.description)
        if let reason = offer.reason {
            Text(verbatim: reason)
                .textStyle(.body)
        }
    }

    private var titleStyle: TextStyle {
        if isSpecial {
            return .title
        }
        return .dish
    }
}
