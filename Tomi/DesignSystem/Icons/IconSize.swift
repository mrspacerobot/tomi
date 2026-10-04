import CoreGraphics

/// The sizes the design draws a glyph at, in points at the default text size.
nonisolated enum IconSize: Sendable {
    /// The question mark inside the mark of an unsure chip.
    case mark
    /// Inside a chip.
    case small
    /// Inside a button.
    case medium

    var points: CGFloat {
        switch self {
        case .mark: 13
        case .small: 16
        case .medium: 20
        }
    }
}
