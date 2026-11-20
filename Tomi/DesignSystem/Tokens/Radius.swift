import CoreGraphics

/// The corner radii of the design, in points. Nothing else is rounded; the stamp is a circle.
nonisolated enum Radius {
    /// Tick boxes and tags.
    static let tag: CGFloat = 2
    /// Chips, fields and boxes.
    static let chip: CGFloat = 3
    static let button: CGFloat = 4
    static let sheet: CGFloat = 16
}
