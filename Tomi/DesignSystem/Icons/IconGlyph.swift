import CoreGraphics

/// The small line drawings of the design kit (`ICONS` in `docs/design/src`), drawn in code like everything else.
nonisolated enum IconGlyph: CaseIterable, Sendable {
    case check
    case plus
    case close
    case lock
    case camera
    case question
    case back

    /// The side of the square grid the kit draws every glyph on, in points.
    static let gridSize: CGFloat = 24

    /// How heavy the kit draws the line of the glyph, on that grid.
    var strokeWeight: CGFloat {
        switch self {
        case .check, .question: 2.6
        case .back: 2
        case .plus, .close, .lock: 2.2
        case .camera: 1.8
        }
    }
}
