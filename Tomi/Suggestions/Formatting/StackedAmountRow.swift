import SwiftUI

/// The name with its amount under it, for text sizes where the one-line row does not fit.
struct StackedAmountRow: View {
    let name: String
    let amount: String?
    var showCardStyle = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text(verbatim: name)
                .textStyle(nameStyle)
            if let amount {
                Text(verbatim: amount)
                    .textStyle(amountStyle)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
