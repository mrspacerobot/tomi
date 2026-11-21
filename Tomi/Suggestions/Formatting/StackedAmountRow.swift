import SwiftUI

/// The name with its amount under it, for text sizes where the one-line row does not fit.
struct StackedAmountRow: View {
    let name: String
    let amount: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text(verbatim: name)
                .textStyle(.showBodyStrong)
            if let amount {
                Text(verbatim: amount)
                    .textStyle(.showMeta)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}
