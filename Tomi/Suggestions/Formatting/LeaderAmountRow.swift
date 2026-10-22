import SwiftUI

/// The name, a dotted leader and the amount on one line. It does not fit when the name would need two lines.
struct LeaderAmountRow: View {
    let name: String
    let amount: String?

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Spacing.xSmall) {
            Text(verbatim: name)
                .textStyle(.dish)
                .lineLimit(1)
            if let amount {
                DottedLeader()
                Text(verbatim: amount)
                    .textStyle(.status)
                    .lineLimit(1)
            }
        }
    }
}
