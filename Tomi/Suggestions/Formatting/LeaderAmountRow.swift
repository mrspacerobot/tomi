import SwiftUI

/// The name, a dotted leader and the amount on one line. It does not fit when the name would need two lines.
struct LeaderAmountRow: View {
    let name: String
    let amount: String?
    var showCardStyle = false

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Spacing.xSmall) {
            Text(verbatim: name)
                .textStyle(nameStyle)
                .lineLimit(1)
            if let amount {
                DottedLeader()
                Text(verbatim: amount)
                    .textStyle(amountStyle)
                    .lineLimit(1)
            }
        }
    }

    private var nameStyle: TextStyle {
        if showCardStyle { return .showBodyStrong }
        return .dish
    }

    private var amountStyle: TextStyle {
        if showCardStyle { return .showMeta }
        return .status
    }

}
