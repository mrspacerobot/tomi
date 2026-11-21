import CoreGraphics

/// The corner radii of the design, in points. Nothing else is rounded; the stamp is a circle.
nonisolated enum Radius {
    /// Tick boxes and tags.
    static let tag: CGFloat = 2
    /// Chips, fields and boxes.
    static let chip: CGFloat = 3
    static let button: CGFloat = 4
    static let sheet: CGFloat = 16

    static let showSheet: CGFloat = 37
    static let showMonitor: CGFloat = 34
    static let showCard: CGFloat = 29
    static let showMarquee: CGFloat = 26
    static let showMarqueePanel: CGFloat = 17
    static let showButton: CGFloat = 23
    static let showControl: CGFloat = 20
    static let showIcon: CGFloat = 17
    static let showSmall: CGFloat = 13
}
