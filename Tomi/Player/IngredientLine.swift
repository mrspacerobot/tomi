import SwiftUI
import TomiCore

/// One ingredient and its amount, formatted for the cook's language.
struct IngredientLine: View {
    let name: String
    let amount: Amount

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Spacing.xSmall) {
            Text(verbatim: name)
                .textStyle(.dish)
            DottedLeader()
            Text(verbatim: AmountFormat.text(for: amount))
                .textStyle(.status)
        }
        .accessibilityElement(children: .combine)
    }
}
