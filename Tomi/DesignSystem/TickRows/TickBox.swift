import SwiftUI

/// The square a cook ticks. Empty it is an outline; ticked it carries a red pen tick that runs out of the
/// box at the top right, so ticked and empty differ in shape and not only in colour.
struct TickBox: View {
    /// The side of the box at the default text size (`.bx` in the design kit).
    static let side: CGFloat = 26

    let isTicked: Bool
    @ScaledMetric(relativeTo: .title3) private var side = TickBox.side

    var body: some View {
        RoundedRectangle(cornerRadius: Radius.tag)
            .fill(ColorRole.paper.color)
            .strokeBorder(ColorRole.cobalt.color, lineWidth: RuleWeight.outline)
            .frame(width: side, height: side)
            .overlay(alignment: .topLeading) {
                if isTicked {
                    TickMark(scale: side / Self.side)
                }
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: Spacing.xLarge) {
        TickBox(isTicked: false)
        TickBox(isTicked: true)
    }
    .padding(Spacing.xLarge)
    .background(ColorRole.wash.color)
}
