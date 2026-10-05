import SwiftUI

/// The hairline between two stats: upright between columns, lying between stats stacked for large text.
struct StatDivider: View {
    let isStacked: Bool

    var body: some View {
        Rectangle()
            .fill(ColorRole.rule.color)
            .frame(width: width, height: height)
            .accessibilityHidden(true)
    }

    /// Nil lets the line run the whole width of the stat under it.
    private var width: CGFloat? {
        if isStacked {
            return nil
        }
        return RuleWeight.hairline
    }

    /// Nil lets the line run the whole height of the stat beside it.
    private var height: CGFloat? {
        if isStacked {
            return RuleWeight.hairline
        }
        return nil
    }
}

#Preview {
    HStack(spacing: Spacing.xLarge) {
        StatDivider(isStacked: false)
        StatDivider(isStacked: true)
    }
    .frame(height: TouchTarget.button)
    .padding()
    .background(ColorRole.paper.color)
}
