import SwiftUI

/// Takes the frame a screen offers Tomi and draws his whole grid around it, larger than the frame, so that
/// Tomi at rest fills the frame while a jump, thought dots or sparkles spill past its edges. The arithmetic
/// is `CompanionGrid.canvas(in:)`.
nonisolated struct CompanionOverflowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        proposal.replacingUnspecifiedDimensions(by: CompanionGrid.figureBox.size)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let canvas = CompanionGrid.canvas(in: bounds.size)
        let origin = CGPoint(x: bounds.minX + canvas.minX, y: bounds.minY + canvas.minY)
        for subview in subviews {
            subview.place(at: origin, proposal: ProposedViewSize(canvas.size))
        }
    }
}
