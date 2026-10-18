import SwiftUI

/// The small capital heading above a block of an offer, with a hairline under it.
struct SectionHeading: View {
    let words: LocalizedStringResource

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(words)
                .textStyle(.label)
                .textCase(.uppercase)
                .accessibilityAddTraits(.isHeader)
            Hairline(.cobalt)
        }
    }
}
