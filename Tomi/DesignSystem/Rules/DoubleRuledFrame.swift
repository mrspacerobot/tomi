import SwiftUI

/// The edge of the double-ruled box: a cobalt outline with a hairline just inside it (`.b-special`).
struct DoubleRuledFrame: View {
    /// The corner of the inner hairline, which the kit draws tighter than any other corner.
    static let innerRadius: CGFloat = 1

    var body: some View {
        RoundedRectangle(cornerRadius: Radius.chip)
            .strokeBorder(ColorRole.cobalt.color, lineWidth: RuleWeight.outline)
            .overlay {
                RoundedRectangle(cornerRadius: Self.innerRadius)
                    .strokeBorder(ColorRole.rule.color, lineWidth: RuleWeight.hairline)
                    .padding(RuleWeight.outline + Spacing.xxSmall)
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    DoubleRuledFrame()
        .frame(height: TouchTarget.button * 3)
        .padding()
        .background(ColorRole.paper.color)
}
