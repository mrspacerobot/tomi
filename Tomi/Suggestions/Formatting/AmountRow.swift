import SwiftUI

/// A name and, when there is one, its amount, with the dotted leader of a printed menu between them.
/// When the name and amount do not fit on one line (the largest text sizes) the amount goes under the name,
/// so a word is never broken in the middle.
struct AmountRow: View {
    let name: String
    let amount: String?

    var body: some View {
        ViewThatFits(in: .horizontal) {
            LeaderAmountRow(name: name, amount: amount)
            StackedAmountRow(name: name, amount: amount)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
