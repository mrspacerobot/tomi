import SwiftUI
import TomiCore

/// How much the graph's recipe makes, so its amounts can be read: whole servings, or another amount.
struct SourceYieldLine: View {
    let yields: SourceAmount

    var body: some View {
        if let servings = yields.wholeServings {
            Text(.offerSourceYieldServings(servings))
                .textStyle(.body)
                .accessibilityIdentifier("offer-source-yield")
        } else if let amount = SourceAmountFormat.text(for: yields) {
            Text(.offerSourceYieldAmount(amount))
                .textStyle(.body)
                .accessibilityIdentifier("offer-source-yield")
        }
    }
}
