import CoreGraphics

/// One row of the type table: the cut, and its size and line height in points at the default text size.
nonisolated struct TextMetrics: Hashable, Sendable {
    let typeface: Typeface
    let size: CGFloat
    let lineHeight: CGFloat
}
