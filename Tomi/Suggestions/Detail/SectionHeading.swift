import SwiftUI

/// The small capital heading above a block of a suggestion, with a hairline under it.
struct SectionHeading: View {
    let words: LocalizedStringResource
    var showCardStyle = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Text(words)
                .textStyle(style, color: ink)
                .textCase(.uppercase)
                .accessibilityAddTraits(.isHeader)
            if !showCardStyle { Hairline(.cobalt) }
        }
    }

    private var style: TextStyle {
        if showCardStyle { return .showLabel }
        return .label
    }

    private var ink: ColorRole {
        if showCardStyle { return .showMuted }
        return .inkFaded
    }
}
