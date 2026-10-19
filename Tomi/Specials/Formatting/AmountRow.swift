import SwiftUI

/// A name and, when there is one, its amount, with the dotted leader of a printed menu between them.
struct AmountRow: View {
    let name: String
    let amount: String?

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Spacing.xSmall) {
            Text(verbatim: name)
                .textStyle(.dish)
            if let amount {
                DottedLeader()
                Text(verbatim: amount)
                    .textStyle(.status)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
