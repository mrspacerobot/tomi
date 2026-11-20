import SwiftUI

/// The name, a dotted leader and the amount on one line. It does not fit when the name would need two lines.
struct LeaderAmountRow: View {
    let name: String
    let amount: String?

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Spacing.xSmall) {
            Text(verbatim: name)
                .textStyle(.showBodyStrong)
                .fixedSize(horizontal: true, vertical: false)
            if let amount {
                DottedLeader()
                Text(verbatim: amount)
                    .textStyle(.showMeta)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }

}
