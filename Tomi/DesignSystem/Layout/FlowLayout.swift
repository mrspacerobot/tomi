import SwiftUI

/// Lays chips out like words in a paragraph: side by side, and on to the next row when one is full.
nonisolated struct FlowLayout: Layout {
    var spacing: CGFloat = Spacing.xSmall

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        var cursor = FlowCursor(width: proposal.width ?? .infinity, spacing: spacing)
        for subview in subviews {
            _ = cursor.place(subview.sizeThatFits(itemProposal(within: proposal)))
        }
        return cursor.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var cursor = FlowCursor(width: bounds.width, spacing: spacing)
        for subview in subviews {
            let size = subview.sizeThatFits(itemProposal(within: proposal))
            let origin = cursor.place(size)
            let point = CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y)
            subview.place(at: point, proposal: ProposedViewSize(size))
        }
    }

    /// A chip may be as wide as the whole row and no wider, so a long name wraps inside its chip.
    private func itemProposal(within proposal: ProposedViewSize) -> ProposedViewSize {
        ProposedViewSize(width: proposal.width, height: nil)
    }
}
