import CoreGraphics

/// Places things one after another in rows of a given width, as words are set in lines: a thing that does
/// not fit in what is left of a row starts the next one.
nonisolated struct FlowCursor {
    let width: CGFloat
    let spacing: CGFloat
    private var next = CGPoint.zero
    private var rowHeight: CGFloat = 0
    private var widest: CGFloat = 0

    init(width: CGFloat, spacing: CGFloat) {
        self.width = width
        self.spacing = spacing
    }

    /// The room everything placed so far takes.
    var size: CGSize {
        CGSize(width: widest, height: next.y + rowHeight)
    }

    /// Where a thing of this size goes, measured from the top left corner.
    mutating func place(_ size: CGSize) -> CGPoint {
        let isFirstInRow = next.x == 0
        if !isFirstInRow && next.x + size.width > width {
            startRow()
        }
        let origin = next
        next.x += size.width + spacing
        rowHeight = max(rowHeight, size.height)
        widest = max(widest, origin.x + size.width)
        return origin
    }

    private mutating func startRow() {
        next = CGPoint(x: 0, y: next.y + rowHeight + spacing)
        rowHeight = 0
    }
}
